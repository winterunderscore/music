#! /usr/bin/env bash 

root="./music/"
artists="$(cat music.json | jq -c .[])"

mkdir "$root" 2> /dev/null
echo "created $root if not existing"
while IFS= read -r line;
do
	artist="$(echo $line | jq -rc .artist)"
	echo "created $root$artist if not existing"
	mkdir "$root$artist" 2> /dev/null;

	songs="$(echo $line | jq -rc .songs[])"

	while IFS= read -r song;
	do
		url="$(echo $song | jq -rc .url)"
		name="$(echo $song | jq -rc .name)"

		files=$(ls $root"$artist"/"$name".* 2> /dev/null | wc -l)
		if [ "$files" != "0" ]
		then
			echo "file already exists, skipping: $name by $artist, $url"
		else
			echo "downloading $name by $artist, $url"
#			yt-dlp -o "$root$artist/$name" "$url" -x --embed-metadata --embed-thumbnail --add-metadata --parse-metadata "uploader:%artist%" --parse-metadata "title:%title%" --parse-metadata "upload_date:%(upload_date)[:4]:%date%" --parse-metadata "description:%comment%" --parse-metadata "webpage_url:%www%" -f bestaudio --audio-format opus --audio-quality 320k
			yt-dlp -o "$root$artist/$name" "$url" -x --embed-metadata --embed-thumbnail --add-metadata -f bestaudio --audio-format opus --audio-quality 320k
		fi
	done <<< "$songs"
done <<< "$artists"
