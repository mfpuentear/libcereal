/* echotest.vala
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
using Cereal;

SerialConnection _connection;
char[] _buffer;

void main (string[] args)
{
	if (args.length < 2)
	{
		print ("Must specify a serial port\n");
		return;
	}
	
	_buffer = new char[1024];
	
	_connection = create_serial_connection ();
	_connection.open (args[1]);
	
	if (!_connection.is_opened)
	{
		print ("Can't open %s\n", args[1]);
		return;
	}
	
	_connection.new_data.connect (on_new_data);
	
	var main_loop = new MainLoop (null, false);
	main_loop.run ();
}

void on_new_data ()
{
	var length = _connection.read (_buffer, _buffer.length);
	_connection.write (_buffer, length);
}
