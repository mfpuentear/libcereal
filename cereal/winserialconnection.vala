/* winserialconnection.vala
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
using Windows;

public class Cereal.WinSerialConnection : SerialConnection, GLib.Object
{
	private string _device;
	private int _baud_rate;
	private int _data_bits;
	private int _stop_bits;
	private Parity _parity;
	private FlowControl _flow_control;
	private bool _is_opened;
	
	private Handle _dev_handle;
	private uint _poll_id;
	
	public string device { get { return _device; } }
	public int baud_rate { get { return _baud_rate; } }
	public int data_bits { get { return _data_bits; } }
	public int stop_bits { get { return _stop_bits; } }
	public Parity parity { get { return _parity; } }
	public FlowControl flow_control { get { return _flow_control; } }
	
	public bool is_opened { get { return _is_opened; } }
	
	~WinSerialConnection ()
	{
		close ();
	}
	
	public void open (string device, int baud_rate, int data_bits, int stop_bits, Parity parity, FlowControl flow_control)
	{
		_device = device;
		_baud_rate = baud_rate;
		_data_bits = data_bits;
		_stop_bits = stop_bits;
		_parity = parity;
		_flow_control = flow_control;
		
		if (_is_opened)
			return;
		_dev_handle = CreateFile (_device, GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, 0, null);
		if (_dev_handle == INVALID_HANDLE_VALUE)
			return;
		
		Dcb settings = { 0 };
		GetCommState (_dev_handle, settings);
		
		//baud_rate
		switch (_baud_rate)
		{
			case 300: settings.BaudRate = CBR_300; break;
			case 600: settings.BaudRate = CBR_600; break;
			case 1200: settings.BaudRate = CBR_1200; break;
			case 2400: settings.BaudRate = CBR_2400; break;
			case 4800: settings.BaudRate = CBR_4800; break;
			case 9600: settings.BaudRate = CBR_9600; break;
			case 19200: settings.BaudRate = CBR_19200; break;
			case 38400: settings.BaudRate = CBR_38400; break;
			case 57600: settings.BaudRate = CBR_57600; break;
			case 115200: settings.BaudRate = CBR_115200; break;
		}
		
		//data_bits
		switch (_data_bits)
		{
			case 5: settings.ByteSize = 5; break;
			case 6: settings.ByteSize = 6; break;
			case 7: settings.ByteSize = 7; break;
			case 8:
			default: settings.ByteSize = 8; break;
		}
		
		//stop_bits
		switch (_stop_bits)
		{
			case 1: settings.StopBits = ONESTOPBIT; break;
			case 2:
			default: settings.StopBits = TWOSTOPBITS; break;
		}
		
		//parity
		switch (_parity)
		{
			case Parity.NONE: settings.Parity = NOPARITY; break;
			case Parity.ODD: settings.Parity = ODDPARITY; break;
			case Parity.EVEN: settings.Parity = EVENPARITY; break;
		}
		
		SetCommState (_dev_handle, settings);
		SetupComm (_dev_handle, 1024, 1024);
		CommTimeouts comm_timeout = {};
		GetCommTimeouts (_dev_handle, comm_timeout);
		comm_timeout.ReadIntervalTimeout = MAXDWORD;
		comm_timeout.ReadTotalTimeoutMultiplier = 0;
		comm_timeout.ReadTotalTimeoutConstant = 0;
		comm_timeout.WriteTotalTimeoutMultiplier = 10;
		comm_timeout.WriteTotalTimeoutConstant = 1000;
		SetCommTimeouts (_dev_handle, comm_timeout);
		
		_poll_id = Timeout.add (250, on_input);
		_is_opened = true;
	}
	
	public void close ()
	{
		if (!_is_opened)
			return;
		Source.remove (_poll_id);
		CloseHandle (_dev_handle);
		_dev_handle = INVALID_HANDLE_VALUE;
		_is_opened = false;
	}
	
	public ssize_t read (void* buffer, size_t length)
	{
		if (!_is_opened)
			return 0;
		ulong bytes_read;
		ReadFile (_dev_handle, buffer, (uint)length, out bytes_read, null);
		return (ssize_t)bytes_read;
	}
	
	public ssize_t write (void* buffer, size_t length)
	{
		if (!_is_opened)
			return 0;
		ulong bytes_written;
		WriteFile (_dev_handle, buffer, (uint)length, out bytes_written, null);
		return (ssize_t)bytes_written;
	}
	
	public void flush ()
	{
		if (!_is_opened)
			return;
		PurgeComm (_dev_handle, PURGE_RXABORT | PURGE_RXCLEAR);
		PurgeComm (_dev_handle, PURGE_TXABORT | PURGE_TXCLEAR);
	}
	
	private bool on_input ()
	{
		ComStat comstat = { };
		uint errors = 0;
		ClearCommError (_dev_handle, out errors, comstat);
		if (comstat.cbInQue > 0)
			this.new_data ();
		return true;
	}
}
