#!/bin/sh
#-----------------------------------------------------------------------------
#	 $Id: webexamples.sh,v 1.24 2010-01-05 03:49:47 guru Exp $
#
#	webexamples.sh - Automatic generation of the GMT examples pages
#
#	To be run from the GMT/website directory
#
#	Author:	Paul Wessel
#	Date:	26-APR-2008
#
#	Script that creates the examples web pages from
#	the scripts files and resulting postscript files
#	Files created in the local www directory in website:
#
#	gmt/gmt_examples.html
#	gmt/examples/gmt_example_??.html
#	gmt/examples/gmt_example_??.ps (copy from examples directory)
#	gmt/examples/example_??_50dpi.png (using ps2raster)
#	gmt/examples/example_??_100dpi.png (using ps2raster)
#-----------------------------------------------------------------------------

n_examples=30

GMT050dpi="ps2raster -E50 -Tg -P"
GMT100dpi="ps2raster -E100 -Tg -P"

if [ $# -eq 1 ]; then
	gush=0
else
	gush=1
fi

cd ..
if [ ! -d src ]; then
	echo "Must be run from main GMT directory - aborts"
	exit
fi

date=`date`
TOP=`pwd`
mkdir -p website/www/gmt
cd website/www/gmt

cat << EOF > gmt_examples.html
<!-- gmt_example.html - Automatically generated by webexamples.sh on $date -->
<title>GMT Examples</title>
<body bgcolor="#ffffff">
<H2>Examples of GMT output</H2>
Each of the $n_examples examples in the GMT Technical Reference and Cookbook may
be viewed individually by clicking on the desired example. The images are
reduced to speed up transmission; clicking on these images will open up
a more detailed image. You will also have the option of viewing the responsible
GMT script and download the complete PostScript illustration.
<OL>
<LI>
<A HREF="examples/ex01/gmt_example_01.html">Contour map of global data
set.</A></LI>

<LI>
<A HREF="examples/ex02/gmt_example_02.html">Color images of gridded data.</A></LI>

<LI>
<A HREF="examples/ex03/gmt_example_03.html">Spectral comparisons and x-y
plots.</A></LI>

<LI>
<A HREF="examples/ex04/gmt_example_04.html">3-D perspective, mesh-line surface</A></LI>

<LI>
<A HREF="examples/ex05/gmt_example_05.html">3-D perspective, artificially
illuminated grayshaded image.</A></LI>

<LI>
<A HREF="examples/ex06/gmt_example_06.html">Two types of histograms.</A></LI>

<LI>
<A HREF="examples/ex07/gmt_example_07.html">A typical location map.</A></LI>

<LI>
<A HREF="examples/ex08/gmt_example_08.html">A 3-D bar graph.</A></LI>

<LI>
<A HREF="examples/ex09/gmt_example_09.html">Time/space-series plotted along
tracks.</A></LI>

<LI>
<A HREF="examples/ex10/gmt_example_10.html">Superposition of 3-D bargraph
and map.</A></LI>

<LI>
<A HREF="examples/ex11/gmt_example_11.html">The RGB color cube.</A></LI>

<LI>
<A HREF="examples/ex12/gmt_example_12.html">Delaunay triangulation, contouring,
and imaging.</A></LI>

<LI>
<A HREF="examples/ex13/gmt_example_13.html">Plotting of vector fields.</A></LI>

<LI>
<A HREF="examples/ex14/gmt_example_14.html">Gridding, contouring, and trend
surfaces.</A></LI>

<LI>
<A HREF="examples/ex15/gmt_example_15.html">Gridding with missing data.</A></LI>

<LI>
<A HREF="examples/ex16/gmt_example_16.html">More gridding options.</A></LI>

<LI>
<A HREF="examples/ex17/gmt_example_17.html">Blending images using clipping.</A></LI>

<LI>
<A HREF="examples/ex18/gmt_example_18.html">Volumes and spatial selections.</A></LI>

<LI>
<A HREF="examples/ex19/gmt_example_19.html">GMT color patterns</A></LI>

<LI>
<A HREF="examples/ex20/gmt_example_20.html">Extending GMT with custom symbols.</A></LI>

<LI>
<A HREF="examples/ex21/gmt_example_21.html">Demonstrating time-series annotations.</A></LI>

<LI>
<A HREF="examples/ex22/gmt_example_22.html">Map legend for global seismicity plot.</A></LI>

<LI>
<A HREF="examples/ex23/gmt_example_23.html">Spherical distances on the Earth.</A></LI>

<LI>
<A HREF="examples/ex24/gmt_example_24.html">Geospatial filtering of data.</A></LI>

<LI>
<A HREF="examples/ex25/gmt_example_25.html">Global distribution of antipodes.</A></LI>

<LI>
<A HREF="examples/ex26/gmt_example_26.html">General vertical perspective projection.</A></LI>

<LI>
<A HREF="examples/ex27/gmt_example_27.html">Plotting Sandwell/Smith Mercator grids.</A></LI>

<LI>
<A HREF="examples/ex28/gmt_example_28.html">Mixing UTM and geographic data.</A></LI>

<LI>
<A HREF="examples/ex29/gmt_example_29.html">Spherical surface gridding using Green's functions.</A></LI>
</OL>
</BODY>
</HTML>
EOF

mkdir -p examples
cd examples
E=
i=1

#	Go over all examples and generate HTML, GIF etc

if [ $gush ]; then
	echo "webexamples.sh: Preparing the example web pages and images"
fi
while [ $i -le $n_examples ]; do

	number=`echo $i | awk '{printf "%2.2d\n", $1}'`
	dir=`echo "ex$number"`

	if [ $gush ]; then
		echo "Working on example $number"
	fi

	mkdir -p $dir
	cd $dir

#	Extract Bourne shell example script and rename

	cp -f $TOP/share/doc/gmt/examples/$dir/job${number}.sh job${number}.sh.txt

#	Copy over the example PS file

	cp -f $TOP/share/doc/gmt/examples/$dir/example_${number}.ps .

#	TMP FIX FOR EX19 SINCE GS IS FUCKED
	if [ $number -eq 19 ]; then
		echo "webexamples.sh: Kludge to make Ex 19 pass through buggy gs"
		grep -v showpage example_${number}.ps | sed -e 's/scale 0 A/scale 0 A showpage/g' > new.ps
		mv -f new.ps example_${number}.ps
	fi
		 
#	Make the PNG at both 50 and 100 dpi, rotating the landscape ones

	$GMT100dpi $rot example_${number}.ps
	mv example_${number}.png example_${number}_100dpi.png
	$GMT050dpi $rot example_${number}.ps
	mv example_${number}.png example_${number}_50dpi.png

#	Write the html file

cat << EOF > gmt_example_${number}.html
<HTML>
<!-- gmt_example_${number}.html - Automatically generated by webexamples.sh  -->
<TITLE>GMT - Example ${number}</title>
<BODY bgcolor="#ffffff">
<CENTER>
<A HREF="example_${number}_100dpi.png">
<img src="example_${number}_50dpi.png">
</A><P></CENTER>
EOF
	tail +2 ../../../../../website/job${number}.txt >> gmt_example_${number}.html

cat << EOF >> gmt_example_${number}.html
<p>
<A HREF="job${number}.sh.txt"><IMG SRC="../../gmt_script.gif" ALT="RETURN">View GMT script.</A>
<A HREF="example_${number}.zip"><IMG SRC="../../gmt_ps.gif" ALT="RETURN">Download zipped PostScript file.</A>
<A HREF="../../gmt_examples.html"><IMG SRC="../../doc/gmt/html/gmt_back.gif" ALT="RETURN">Back</A>
</BODY>
</HTML>
EOF

	cd ..

	i=`expr $i + 1`
done
