#!/bin/sh

if [ $1 = "help" ]; then
  echo "This container provides all the utilities from the GoPro-dashboard-overlay project"
  echo "at github: https://github.com/time4tea/gopro-dashboard-overlay"
  echo "The command line tools included are:"
  echo ""
  echo "gopro-contrib-data-extract.py
gopro-cut.py
gopro-dashboard.py
gopro-extract.py
gopro-join.py
gopro-rename.py
gopro-to-csv.py
gopro-to-gpx.py"
echo ""
echo "Place a video file in the video folder and run with docker-compose up overlay for the default settings"
echo "Which will run the example:
gopro-dashboard.py --gpx video.gpx(created if not found) video.MP4 video-dashboard.MP4"

  exit 1
fi

if [ $1 = "bash" ]; then
	echo "Starting bash"
	exec "$@"
fi

if [ `echo "$1" | cut -c -5` = "gopro" ]; then
	echo "executing gopro cmd"
	exec "$@"
fi

if [ $1 = auto ];
then

epfilecount()
{
	epVFCPattern=${1:-*[mM][pP]4}
	epVFC=`ls /videos/${epVFCPattern} 2> /dev/null |wc -l`
	if [ $epVFC = 0 ]; then
		echo "0"
	else 
		echo $epVFC
	fi
}


echo "Checking files"
if [ `epfilecount` -ne 1 ]; then 
	echo "Multiple video files found, joining them"
	# do a join
fi

if [ `epfilecount` -ne `epfilecount '*.[gG][pP][xX]'` ]
then
	echo "Extracting GPX data"
	for vfile in `ls /videos/*.[mM][pP]4`
	do
		gopro-to-gpx.py $vfile /videos/$(basename $vfile .MP4).GPX
	done
else
	echo "Creating overlay with GPX file"
	cd /videos
	for vfile in *.[mM][pP]4
	do
		gopro-dashboard.py --gpx $(basename $vfile .MP4).GPX $vfile $(basename $vfile .MP4)-OV.MP4
	done
fi

echo "All done!"
exit
fi
