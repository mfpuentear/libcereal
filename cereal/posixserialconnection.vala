/* posixserialconnection.vala
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
using Posix;

public class Cereal.PosixSerialConnection : SerialConnection, GLib.Object
{
	[CCode (cname="CRTSCTS", cheader_filename="termios.h")]
	private extern const tcflag_t CRTSCTS;
	
	private string _device;
	private int _baud_rate;
	private int _data_bits;
	private int _stop_bits;
	private Parity _parity;
	private FlowControl _flow_control;
	private bool _is_opened;
	
	private int _fd;
	private IOChannel _iochannel;
	private uint _source_id;
	
	public string device { get { return _device; } }
	public int baud_rate { get { return _baud_rate; } }
	public int data_bits { get { return _data_bits; } }
	public int stop_bits { get { return _stop_bits; } }
	public Parity parity { get { return _parity; } }
	public FlowControl flow_control { get { return _flow_control; } }
	
	public bool is_opened { get { return _is_opened; } }
	
	~PosixSerialConnection ()
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
		_fd = Posix.open (_device, O_RDWR | O_NOCTTY | O_NONBLOCK);
		if (_fd == -1)
			return;
		
		termios settings = { 0 };
		tcgetattr (_fd, settings);
		
		//baud_rate
		speed_t speed = 0;
		switch (_baud_rate)
		{
			case 300: speed = B300; break;
			case 600: speed = B600; break;
			case 1200: speed = B1200; break;
			case 2400: speed = B2400; break;
			case 4800: speed = B4800; break;
			case 9600: speed = B9600; break;
			case 19200: speed = B19200; break;
			case 38400: speed = B38400; break;
			case 57600: speed = B57600; break;
			case 115200: speed = B115200; break;
		}
		cfsetispeed (settings, speed);
		cfsetispeed (settings, speed);
		
		//data_bits
		settings.c_cflag &= ~CSIZE;
		switch (_data_bits)
		{
			case 5:
				settings.c_cflag |= CS5;
				break;
			case 6:
				settings.c_cflag |= CS6;
				break;
			case 7:
				settings.c_cflag |= CS7;
				break;
			case 8:
			default:
				settings.c_cflag |= CS8;
				break;
		}
		
		//stop_bits
		switch (_stop_bits)
		{
			case 2:
				settings.c_cflag |= CSTOPB;
				break;
			case 1:
			default:
				settings.c_cflag &= ~CSTOPB;
				break;
		}
		
		//parity
		switch (_parity)
		{
			case Parity.NONE:
				settings.c_cflag &= ~(PARENB | PARODD);
				settings.c_iflag &= ~INPCK;
				break;
			case Parity.ODD:
				settings.c_cflag |= (PARENB | PARODD);
				settings.c_iflag |= INPCK;
				break;
			case Parity.EVEN:
				settings.c_cflag |= PARENB;
				settings.c_cflag &= ~PARODD;
				settings.c_iflag |= INPCK;
				break;
		}
		
		//flow_control
		switch (_flow_control)
		{
			case FlowControl.NONE:
				settings.c_iflag &= ~(IXON | IXOFF | IXANY);
				settings.c_cflag &= ~CRTSCTS;
				break;
			case FlowControl.SOFTWARE:
				settings.c_iflag |= (IXON | IXOFF | IXANY);
				settings.c_cflag &= ~CRTSCTS;
				break;
			case FlowControl.HARDWARE:
				settings.c_iflag &= ~(IXON | IXOFF | IXANY);
				settings.c_cflag |= CRTSCTS;
				break;
			case FlowControl.BOTH:
				settings.c_iflag |= (IXON | IXOFF | IXANY);
				settings.c_cflag |= CRTSCTS;
				break;
		}
		
		//timeout
		settings.c_cc[VTIME] = 1;
		settings.c_cc[VMIN] = 1;
		settings.c_cflag |= (CLOCAL | CREAD);
		settings.c_lflag &= ~(ICANON | ECHO | ECHOE | IEXTEN);
		settings.c_iflag &= ~(BRKINT | ICRNL | ISTRIP );
		settings.c_oflag &= ~OPOST;
		tcsetattr (_fd, TCSANOW, settings);
		
		_iochannel = new IOChannel.unix_new (_fd);
		_source_id = _iochannel.add_watch (IOCondition.IN, on_input);
		Posix.sleep (1);
		_is_opened = true;
	}
	
	public void close ()
	{
		if (!_is_opened)
			return;
		Source.remove (_source_id);
		_iochannel.shutdown (true);
		_iochannel = null;
		Posix.close (_fd);
		_fd = -1;
		_is_opened = false;
	}
	
	public ssize_t read (void* buffer, size_t length)
	{
		if (!_is_opened)
			return 0;
		return Posix.read (_fd, buffer, length);
	}
	
	public ssize_t write (void* buffer, size_t length)
	{
		if (!_is_opened)
			return 0;
		return Posix.write (_fd, buffer, length);
	}
	
	public void flush ()
	{
		tcflush (_fd, TCIOFLUSH);
	}
	
	private bool on_input (IOChannel source, IOCondition condition)
	{
		if (IOCondition.IN in condition)
		{
			this.new_data ();
			return true;
		}
		return false;
	}
}
