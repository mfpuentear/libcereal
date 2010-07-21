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

public class Cereal.StringStream : GLib.Object
{
	private SerialConnection _serial_connection;
	private StringBuilder _buffer = new StringBuilder ();
	private string _line;
	private char null_char = '\0';
	
	public string? read_line_end { set; get; }
	public string? write_line_end { set; get; }
	
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
		if (!_serial_connection.is_opened || line.length == 0)
			return;
		_serial_connection.write ((char[])line, line.length);
		if (_write_line_end == null)
			_serial_connection.write (&null_char, 1);
		else if (_write_line_end != "")
			_serial_connection.write ((char[])_write_line_end, _write_line_end.length);
	}
	
	private void on_new_data ()
	{
		char data = '\0';
		if (_serial_connection.read (&data, 1) == 0)
			return;
		
		if (data == '\0')
		{
			flush_buffer ();
			return;
		}
		
		_buffer.append_c (data);
		if (_read_line_end != null && _buffer.str.has_suffix (_read_line_end))
		{
			_buffer.truncate (_buffer.len - _read_line_end.length);
			flush_buffer ();
		}
	}
	
	private void flush_buffer ()
	{
		if (_buffer.len == 0)
			return;
		_line = _buffer.str;
		_buffer.erase ();
		this.new_line ();
	}
}
