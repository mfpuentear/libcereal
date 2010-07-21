/* stringstreamtest.vala
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

void main (string[] args)
{
	if (args.length < 2)
	{
		print ("Must specify a serial port\n");
		return;
	}
	
	var connection = create_serial_connection ();
	connection.open (args[1]);
	
	if (!connection.is_opened)
	{
		print ("Can't open %s\n", args[1]);
		return;
	}
	
	var string_stream = new StringStream (connection);
	string_stream.read_line_end = "\r\n";
	string_stream.write_line_end = "\r\n";
	
	string_stream.new_line.connect (() => {
		var line = string_stream.read_line ();
		if (line == "ping")
			string_stream.write_line ("pong");
		else
			print (line + "\n");
	});
	
	var main_loop = new MainLoop (null, false);
	main_loop.run ();
}
