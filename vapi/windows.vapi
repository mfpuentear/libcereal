/* windows.vapi
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

[CCode (lower_case_cprefix="", cheader_filename="windows.h")]
namespace Windows
{
	[CCode (cname = "HANDLE")]
	[IntegerType (rank = 7)]
	public struct Handle {
	}
	
	public const uint CBR_110;
	public const uint CBR_300;
	public const uint CBR_600;
	public const uint CBR_1200;
	public const uint CBR_2400;
	public const uint CBR_4800;
	public const uint CBR_9600;
	public const uint CBR_14400;
	public const uint CBR_19200;
	public const uint CBR_38400;
	public const uint CBR_57600;
	public const uint CBR_115200;
	public const uint CBR_120000;
	public const uint CBR_256000;
	public const uchar NOPARITY;
	public const uchar ODDPARITY;
	public const uchar EVENPARITY;
	public const uchar MARKPARITY;
	public const uchar SPACEPARITY;
	public const uchar ONESTOPBIT;
	public const uchar ONE5STOPBITS;
	public const uchar TWOSTOPBITS;
	public const uint GENERIC_READ;
	public const uint GENERIC_WRITE;
	public const uint OPEN_EXISTING;
	public const Handle INVALID_HANDLE_VALUE;
	public const int PURGE_RXABORT;
	public const int PURGE_RXCLEAR;
	public const int PURGE_TXABORT;
	public const int PURGE_TXCLEAR;
	public const uint MAXDWORD;
	
	[CCode (cname = "DCB")]
	public struct Dcb
	{
		public uint DCBlength;
		public uint BaudRate;
		public bool fBinary;
		public bool fParity;
		public bool fOutxCtsFlow;
		public bool fOutxDsrFlow;
		public uint fDtrControl;
		public bool fDsrSensitivity;
		public bool fTXContinueOnXoff;
		public bool fOutX;
		public bool fInX;
		public bool fErrorChar;
		public bool fNull;
		public uint fRtsControl;
		public bool fAbortOnError;
		public uint fDummy2;
		public uint8 wReserved;
		public uint8 XonLim;
		public uint8 XoffLim;
		public uchar ByteSize;
		public uchar Parity;
		public uchar StopBits;
		public char  XonChar;
		public char  XoffChar;
		public char  ErrorChar;
		public char  EofChar;
		public char  EvtChar;
		public uint8 wReserved1;
	}
	
	[CCode (cname = "COMMTIMEOUTS")]
	public struct CommTimeouts
	{
		public uint ReadIntervalTimeout;
		public uint ReadTotalTimeoutMultiplier;
		public uint ReadTotalTimeoutConstant;
		public uint WriteTotalTimeoutMultiplier;
		public uint WriteTotalTimeoutConstant;
	}
	
	[CCode (cname = "COMSTAT")]
	public struct ComStat
	{
		public bool fCtsHold;
		public bool fDsrHold;
		public bool fRlsdHold;
		public bool fXoffHold;
		public bool fXoffSent;
		public bool fEof;
		public bool fTxim;
		public uint fReserved;
		public uint cbInQue;
		public uint cbOutQue;
	}
	
	// Functions
	public bool GetCommState (Handle handle, Dcb dcb);
	public bool SetCommState (Handle handle, Dcb dcb);
	public bool GetCommTimeouts (Handle handle, CommTimeouts commtimeouts);
	public bool SetCommTimeouts (Handle handle, CommTimeouts commtimeouts);
	public bool SetupComm (Handle handle, uint in_buffer, uint out_buffer);
	public bool PurgeComm (Handle handle, int flags);
	public bool ClearCommError (Handle handle, out uint error, ComStat comstat);
	
	public Handle CreateFile (string filename, uint desired_access, uint share_mode, uint security_attributes, uint creation_distribution, uint flags_and_attributes, void* template_file);
	public bool CloseHandle (Handle object);
	public bool ReadFile (Handle file, void* buffer, uint number_of_bytes_to_read, out ulong number_of_bytes_read, void* overlapped);
	public bool WriteFile (Handle file, void* buffer, uint number_of_bytes_to_write, out ulong number_of_bytes_written, void* overlapped);
}

