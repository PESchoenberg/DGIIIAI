# DGIIIAI - Intelligent Delta Glider.




## Overview:

Semi-autonomous variant of the stock Orbiter Space Flight Simulator Delta Glider 
III equipped with its own SQL expert-system-based AI.


## Dependencies:

* Orbiter Space Flight Simulator (OSFS) ver 2010 or newer 
- http://orbit.medphys.ucl.ac.uk/

* MS Visual Studio ver 2010 or newer with OpenMP compatibility.

* Sqlite3 - https://www.sqlite.org/index.html 

* SQLC - https://github.com/PESchoenberg/SQLC.git


## Installation:

* Backup your original Orbiter installation or install a new one before
installation.

* Carefully review the contents of the compressed file of this project
in order to see what will be copied.

* Copy the contents of /orbiter folder into your Orbiter simulator main folder.


## Uninstall:

* You will have to manually remove the files provided. Therefore it is
advisable that you install this project on a development installation of
Orbiter instead of you main one.


## Usage:

* Note that the code will not compile if you don't have OpenMP on your
system or MSVS doesn't link to it.

* Also note that you will need a CPU with at least two cores to run DGIIIAI
due to the fact that the code is multi-threaded.

* Load one of the provided scenarios. The ship will soon start acting on its
own.


## Credits and Sources:

* Dr. Martin Schweiger, for OSFS.

* Credits for the original DGIII files are kept as in the original version.

* Please notify me in case that I have missed some credits.


## License:

* Please read the contents of file COPYING for license info.


