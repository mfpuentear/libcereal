/* bytestream.vala
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

public class Cereal.ByteStream : GLib.Object
{
	private SerialConnection _serial_connection;
	private ByteArray _buffer = new ByteArray ();
	private uint8[] _bytes;
	private ssize_t _count;
	
	public ssize_t read_length { set; get; default=1; }
	
	public signal void new_data ();
	
	public ByteStream (SerialConnection serial_connection)
	{
		_serial_connection = serial_connection;
		_serial_connection.new_data.connect (on_new_data);
	}
	
	public uint8 read_byte ()
	{
		return _bytes[0];
	}
	
	public void write_byte (uint8 byte)
	{
		_serial_connection.write (&byte, 1);
	}
	
	public uint8[] read_bytes ()
	{
		return _bytes;
	}
	
	public void write_bytes (uint8[] bytes)
	{
		_serial_connection.write (bytes, bytes.length);
	}
	
	public void flush_buffer ()
	{
		if (_buffer.len == 0)
			return;
		_bytes = _buffer.data;
		_buffer.set_size (0);
		_count = 0;
		this.new_data ();
	}
	
	private void on_new_data ()
	{
		var data = new uint8[1];
		if (_serial_connection.read (data, 1) == 0)
			return;
		
		if (_read_length == 1)
		{
			_bytes = data;
			this.new_data ();
		}
		
		_buffer.append (data);
		_count++;
		if (_count == _read_length)
			flush_buffer ();
	}
}
