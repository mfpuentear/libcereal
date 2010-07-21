/* stringstream.vala
 *
 * Copyright (C) 2010  Matias De la Puente
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 * 	Matias De la Puente <mfpuente.ar@gmail.com>
 */

public enum Cereal.LineEnd
{
	CR,
	CRLF,
	ESC,
	LF,
	NONE,
	NULL,
	SPACE,
	TAB
}

public class Cereal.StringStream : GLib.Object
{
	private SerialConnection _serial_connection;
	private StringBuilder _buffer = new StringBuilder ();
	private string _line;
	private bool _cr_received;
	
	public LineEnd read_line_end { set; get; default=LineEnd.NULL; }
	public LineEnd write_line_end { set; get; default=LineEnd.NULL; }
	
	public signal void new_line ();
	
	public StringStream (SerialConnection serial_connection)
	{
		_serial_connection = serial_connection;
		_serial_connection.new_data.connect (on_new_data);
	}
	
	public string read_line ()
	{
		return _line;
	}
	
	public void write_line (string line)
	{
		if (!_serial_connection.is_opened)
			return;
		_serial_connection.write ((char[])line, line.length);
		switch (_write_line_end)
		{
			case LineEnd.NONE: break;
			case LineEnd.NULL: write_char ('\0'); break;
			case LineEnd.CR: write_char ('\r'); break;
			case LineEnd.CRLF: _serial_connection.write ((char[])"\r\n", 2); break;
			case LineEnd.ESC: write_char ('\x1b'); break;
			case LineEnd.LF: write_char ('\n'); break;
			case LineEnd.SPACE: write_char (' '); break;
			case LineEnd.TAB: write_char ('\t'); break;
		}
	}
	
	private void write_char (char c)
	{
		_serial_connection.write (&c, 1);
	}
	
	private void on_new_data ()
	{
		char data = '\0';
		if (_serial_connection.read (&data, 1) == 0)
			return;
		
		if ((_read_line_end == LineEnd.NULL || _read_line_end == LineEnd.NONE) && data == '\0')
		{
			flush_buffer ();
			return;
		}
		if (_read_line_end == LineEnd.CR && data == '\r')
		{
			flush_buffer ();
			return;
		}
		if (_read_line_end == LineEnd.CRLF)
		{
			if (data == '\r' && !_cr_received)
				_cr_received = true;
			else if (data == '\n' && _cr_received)
			{
				_buffer.truncate (_buffer.len-1);
				_cr_received = false;
				flush_buffer ();
				return;
			}
		}
		if (_read_line_end == LineEnd.ESC && data == '\x1b')
		{
			flush_buffer ();
			return;
		}
		if (_read_line_end == LineEnd.LF && data == '\n')
		{
			flush_buffer ();
			return;
		}
		if (_read_line_end == LineEnd.SPACE && data == ' ')
		{
			flush_buffer ();
			return;
		}
		if (_read_line_end == LineEnd.TAB && data == '\t')
		{
			flush_buffer ();
			return;
		}
		_buffer.append_c (data);
	}
	
	private void flush_buffer ()
	{
		_line = _buffer.str;
		_buffer.erase ();
		this.new_line ();
	}
}
