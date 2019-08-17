# DGIIIAI - Intelligent Delta Glider.

[![DOI](https://zenodo.org/badge/202588435.svg)](https://zenodo.org/badge/latestdoi/202588435)


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
own. You will have to wait a little bit while the ship loads its knowledge base
and starts interpreting every rule.

* The ship is a work in progress. Many rules have been developed and tested, and
now form part of the knowledge base. However, they only cover a fraction of
what a complete set of rules for autonomus flight should be. Currently the KB 
rules cover all start up and atmospheric takeoff, ascent to cruise altitude in 
atmospheric flight, maneuvering and partially, navigation based in great circle 
routes.


## Notes:

* Code for this DG corresponds to Orbiter 2010. I started this development while 
Orbiter 2010 was still the latest and once version 2016 came, the new DG 
incarnation had the code completely rewritten and it was not worth to adapt 
everything again.

* It is relatively lightweight. I normally compile and run it on a Win virtual 
machine inside a Linux system.

* Most work should be oriented now to either:

* Adapt the code to Orbiter 2016.

* Produce more sql code and load it to the expert system database. The ship 
needs more rules, and these are written in sql.

* Create documentation for this project.

* Since documentation is still lacking, in order to gain insight about this 
project, use any Sqlite3 compatible DB editor to take a look inside the 
knowledge base (it is located inside folder /databases). You will see several 
tables that contain facts (i.e. flight parameters) and rules. Those rules are 
written in sql. Don’t change anything unless you really know what you are 
doing. Rules are assembled in “programs” that are loaded and unloaded by the AI 
engine as they are needed.

* Perhaps you will be wondering why build a knowledge base in SQL. Well… I 
actually started with Prolog and built some nice prototypes but Prolog can only 
use flat files for storage and an expert system that makes intensive use of its 
rules – such as a spacecraft or aircraft while it flies – requires something 
that can handle concurrent access to the knowledge base more safely, hence a 
relational database. I initially used MySQL and results were very good but 
Sqlite3 is much faster and easier to install for the end user.

* Notice that having an on-board relational database in an Orbiter spacecraft 
means also that  modules such as MFDs can exchange information between each 
other very easily just by accessing the said database. In fact SQLC, which is 
an MFD that I made in order to actually control the AI engine and access the 
knowledge base (KB) does exactly that: it works with a database of its own (for 
configuration) and interacts with the KB of the ship. Since a relational 
database system takes care of concurrent access to a data table, it is possible 
to have many modules working on the same table at virtually the same time. In 
this regard, MySQL or PostgreSQL offer better characteristics, but Sqlite3 has 
its own advantages, being the main ones simplicity and speed.

* As this is an ongoing project it is not yet apt for use by average OSFS users.
 It has limited functionality. The idea behind posting it as public access
project is to document its existence, serve as basis for derived projects and of 
course, produce all the AI rules required to provide fully autonomous flight. 
Consider this as a beta or pre-production system.


## Related projects:

* gexsys - https://github.com/PESchoenberg/gexsys - This is a Scheme-based 
expert system developed directly from DGIIIAI. There are some differences 
between both, being the main one that the system installed on DGIIIAI is 
specific for this space ship, while gexsys is mre general-purpose, but broadly 
speaking they work very similarly. Thus, you could use both for double feedback 
and testing.


## Credits and Sources:

* Dr. Martin Schweiger, for OSFS.

* Credits for the original DGIII files are kept as in the original version.

* Please notify me in case that I have missed some credits.


## License:

* Please read the contents of file COPYING for license info.


