#include <cereal.h>

CerealSerialConnection* cereal_create_serial_connection ()
{
#if __gnu_linux__
	return (CerealSerialConnection*)cereal_posix_serial_connection_new ();
#elif __WIN32__
	return (CerealSerialConnection*)cereal_win_serial_connection_new ();
#else
	return NULL;
#endif
}
