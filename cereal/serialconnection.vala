/* serialconnection.vala
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

public enum Cereal.Parity
{
	NONE,
	ODD,
	EVEN
}

public enum Cereal.FlowControl
{
	NONE,
	SOFTWARE,
	HARDWARE,
	BOTH
}

public interface Cereal.SerialConnection : GLib.Object
{
	public abstract string device { get; }
	public abstract int baud_rate { get; }
	public abstract int data_bits { get; }
	public abstract int stop_bits { get; }
	public abstract Parity parity { get; }
	public abstract FlowControl flow_control { get; }
	
	public abstract bool is_opened { get; }
	
	public signal void new_data ();
	
	public abstract void open (string device,
	                           int baud_rate=9600,
	                           int data_bits=8,
	                           int stop_bits=1,
	                           Parity parity=Parity.NONE,
	                           FlowControl flow_control=FlowControl.NONE);
	public abstract void close ();
	public abstract ssize_t read (void* buffer, size_t length);
	public abstract ssize_t write (void* buffer, size_t length);
}

namespace Cereal
{
	//Defined in serialconnectionfactory.c
	public extern SerialConnection create_serial_connection ();
}
