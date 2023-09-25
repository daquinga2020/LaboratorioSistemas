#!/bin/sh

echo "Escribe una palabra"

read palabra

case $palabra in

	[aeiouAEIOU]*)
		echo "La palabra empieza por vocal"
		;;
	*[0-9]*)
		echo "¡La palabra contiene un núemro!"
		;;
	*[A-Z]*)
		echo "La palabra contiene mayúsculas"
		;;
	*)
		echo "No cumple ninguna de las condiciones"
		;;
esac

exit 0
