#!/usr/bin/perl
use POSIX qw(strftime);
use POSIX qw(locale_h);
use utf8;
use open ':utf8';
print "Content-type: text/xml\n\n";

$latestepisode = `curl -s http://www.gameone.de/tv | egrep '"/tv/' | head -n1`;
$latestepisode =~ s/.*\/tv\/(\d+).*/\1/g;
chomp($latestepisode);

setlocale(LC_TIME, "en_US");
$rfc822date = strftime("%a, %d %b %Y %H:%M:%S %z", localtime(time()));

print <<OIDSIO;
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:igor="http://emonk.net/IGOR" version="2.0">
    <channel>
        <title>MTV Gameone</title>
        <link>http://xn--fanbys-exa.org</link>
        <atom:link href="http://xn--fanbys-exa.org/episodes.m4a.rss" rel="self" type="application/rss+xml" />
        <language>de-de</language>
        <copyright>cc-by-nc-sa</copyright>
        <itunes:subtitle>MTV Gameone</itunes:subtitle>
        <itunes:author>fanboys</itunes:author>
        <itunes:summary>Spielemagazin</itunes:summary>
		<itunes:explicit>no</itunes:explicit>
        <description>Spielemagazin</description>
OIDSIO

for ($i=$latestepisode;$i>$latestepisode-5;$i--) {
    $url = "http://www.gameone.de/tv/$i\n";
    $mp4 = `/usr/local/bin/get_flash_videos -i $url 2>&1 | grep Content-Location`;
    $mp4 =~ s/\n//g;
    $mp4 =~ s/^.*riptide\/r2/http:\/\/cdn.riptide-mtvn.com\/r2/g;
    chomp($mp4);
    
print <<END;
        <item>
            <title>Game One Folge $i</title>
            <itunes:explicit>no</itunes:explicit>
            <itunes:author>MTV</itunes:author>
            <itunes:subtitle>Folge $i</itunes:subtitle>
            <enclosure url="$mp4" type="video/mp4"/>
            <guid isPermaLink="false">$i</guid>
            <pubDate>$rfc822date</pubDate>
            <itunes:duration>10:00</itunes:duration>
        </item>
END
}


print <<IUDBIUDSNO;
    </channel>
</rss>
IUDBIUDSNO

