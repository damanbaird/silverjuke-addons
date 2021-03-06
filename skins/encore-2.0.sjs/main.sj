program.onLoad = StartSilverjuke;
program.setTimeout(update,1000,true);
player.onTrackChange = ScreenUpdate;

var configname = "EncoreTimer";
var config_showmsg;
var config_idletime;
 

function ScreenUpdate()
	{
	if (player.queueLength >0)
		{
		program.setSkinText("artist",player.getArtistAtPos());
		program.setSkinText("album",player.getAlbumAtPos());
		program.setSkinText("title",player.getTitleAtPos());
		var url = player.getUrlAtPos();
		var ratingstring ="";
		var year = "";
		var genre = "";
		var bitrate = "";
		var samplerate = "";
		var timesplayed = "";
		var channels = ""
		var db = new Database();
		var quoteExpr = new RegExp("'", "g");
		db.openQuery("select rating,year,genrename,timesplayed,bitrate,samplerate,channels from tracks where url ='"+url.replace(quoteExpr,"''")+"';");
		if( db.nextRecord() )
			{
			rating = parseInt(db.getField(0));
			year = db.getField(1);
			if (year == 0)
				{
				year = "";
				}
			program.setSkinText("YearTest", year);
			genre = db.getField(2);
			program.setSkinText("TestGenre",genre);
			timesplayed = db.getField(3);
			program.setSkinText("TestAbspielungen",timesplayed);
			bitrate = db.getField(4);
			samplerate = db.getField(5);
			channels = db.getField(6);
			if (bitrate == 0)
				{
				bitrate = "";
				}
			else
				{
				bitrate = bitrate/1000 + " kbps";
				}
			program.setSkinText("TestBitrate",bitrate);
			if (samplerate == 0)
				{
				samplerate = "";
				}
			else
				{
				samplerate = samplerate/1000 + " kHz";
				}
			program.setSkinText("TestSamplerate",samplerate);	
			if (channels == "2")
				{
				channels = "STEREO";
				}
			else
				{
				channels = "MONO";
				}
			program.setSkinText("TestChannels",channels);
			
			 switch (rating)
			{
			case 0:	
				ratingstring = "";
				break;
			case 1:	
			
				ratingstring = "n";
				break;
			case 2:	
				ratingstring = "nn";
				break;
			case 3:	
				ratingstring = "nnn";
				break;
			case 4:	
				ratingstring = "nnnn";
				break;
			case 5:	
				ratingstring = "nnnnn";
				break;
			}
		program.setSkinText("rating",ratingstring);
			}
		db.closeQuery();
		var pos = player.queuePos;
		var length = parseInt(player.getDurationAtPos()); 
		var min = Math.floor(length/60000);
		var sec = Math.floor(length/1000 - 60 * min);
		min = "0" + min;
		min = min.substr(-2,2);
		sec = "0" + sec;
		sec = sec.substr(-2,2);
		var dauer = "" + min + ":" + sec;
		program.setSkinText("titellength",dauer);
		}
	else
		{
		program.setSkinText("artist","");
		program.setSkinText("album","");
		program.setSkinText("title","");
		program.setSkinText("YearTest","");
		program.setSkinText("TestGenre","");
		program.setSkinText("TestBitrate","");
		program.setSkinText("TestSampleratete","");
		program.setSkinText("TestAbspielungen","");
		program.setSkinText("TestLast","");
		program.setSkinText("TestChannels","");
		program.setSkinText("titellength","00:00");
		program.setSkinText("playlistlength","00:00");
		program.setSkinText("playlistremainlength","00:00");
		program.setSkinText("playlisttotalnumber","0");
		program.setSkinText("playlistremainnumber","0");
		program.setSkinText("next_label","");
		program.setSkinText("next_artist","");
		program.setSkinText("next_title","");
		}
	}



function Ende()
// Programm beenden
	{
	if (confirm('Jukebox wirklich beenden?'))
		{
		program.shutdown(30);
		}
	}

function Shutdown()
// PC herunterfahren
	{
	if (confirm('PC wirklich herunterfahren?'))
		{
		program.shutdown(40);
		}
	}

function NowPlayingOn()
// umschalten auf Layout now_playing
	{
	program.musicSel = '';
	program.layout="now_playing";
	}

function NowPlayingOff()
// verlassen von Layout now_playing
	{
	
	program.viewMode = 1;
	program.layout = "default";
	}
	
	function aktuelleCD()
// verlassen von Layout now_playing
	{
	program.musicSel = '';
	program.viewMode = 0;
	program.layout = "default";
	}
	



	
function update()
	{
	if (program.layout == "now_playing")
		{
		var sysuhr = new Date();
		var u_offset = "" + sysuhr.getTimezoneOffset();
		if (u_offset == "0")
			{
			var u_msec = sysuhr.getTime() + 7200000;
			}
		else
			{
			var u_msec = sysuhr.getTime();
			}
		var uhr = new Date(u_msec);
		var u_wotag = uhr.getDay();
		var u_tag = "0" + uhr.getDate();
		u_tag = u_tag.substr(-2,2);
		var u_monat = "0" + (uhr.getMonth()+1);
		u_monat = u_monat.substr(-2,2);
		var u_jahr = "" + uhr.getFullYear();
		var u_std = "0" + uhr.getHours();
		u_std = u_std.substr(-2,2);
		var u_min = "0" + uhr.getMinutes();
		u_min = u_min.substr(-2,2);
		var u_sec = "0" + uhr.getSeconds();
		u_sec = u_sec.substr(-2,2);
		var u_wota = "";
		switch (u_wotag)
			{
			case 1:  u_wota = "Monday";     break;
			case 2:  u_wota = "Tuesday";   break;
			case 3:  u_wota = "Wednesday";   break;
			case 4:  u_wota = "Thursday"; break;
			case 5:  u_wota = "Friday";    break;
			case 6:  u_wota = "Saturday";    break;
			case 0:  u_wota = "Sunday";    break;
			}
		datum = "" + u_wota + ", " + u_tag + "." + u_monat + "." + u_jahr;
		zeit = "" + u_std + ":" + u_min + ":" + u_sec;
		
		}
	if (player.queueLength >0)
		{
		var i = 0;
		var length = 0;
		for (i = 0; i < player.queueLength; i++)
			{
			length += parseInt(player.getDurationAtPos(i));
			}
		var std = Math.floor(length/3600000);
		var min = Math.floor(length/60000 - 60 * std);
		var sec = Math.floor(length/1000 - 60 * min - 3600 * std);
		min = "0" + min;
		min = min.substr(-2,2);
		sec = "0" + sec;
		sec = sec.substr(-2,2);
		var dauer = "" + std + ":" + min + ":" + sec;
		program.setSkinText("playlistlength",dauer);
		length = parseInt(player.getDurationAtPos()) - parseInt(player.time);
		for (i = player.queuePos + 1 ; i < player.queueLength; i++)
			{
			length += parseInt(player.getDurationAtPos(i));
			}
		std = Math.floor(length/3600000);
		min = Math.floor(length/60000 - 60 * std);
		sec = Math.floor(length/1000 - 60 * min - 3600 * std);
		min = "0" + min;
		min = min.substr(-2,2);
		sec = "0" + sec;
		sec = sec.substr(-2,2);
		dauer = "" + std + ":" + min + ":" + sec;
		program.setSkinText("playlistremainlength",dauer);
		program.setSkinText("playlisttotalnumber",player.queueLength);
		program.setSkinText("playlistremainnumber",player.queueLength-player.queuePos);

		if ((player.isPlaying()) && (program.layout != "now_playing") && (program.layout != "new"))
			{
			if (program.lastUserInput > (config_idletime * 1000))
				{
				NowPlayingOn();
				}
			}
		}
	else
		{
		program.setSkinText("playlistlength","00:00");
		program.setSkinText("playlistremainlength","00:00");
		program.setSkinText("playlisttotalnumber","0");
		program.setSkinText("playlistremainnumber","0");
		if (program.layout == "now_playing")
			{
			if (program.lastUserInput > (config_idletime * 1000))
				{
				NowPlayingOff();
				}
			}
		}
	}




function trim(str)
	{
	while(str.substr(0,1) == ' ') {str = str.substr(1,str.length-1);}
	while((str.substr(str.length-1,1) == ' ') || (str.substr(str.length-1,1) == '\n') || (str.substr(str.length-1,1) == '\r')) {str = str.substr(0,str.length-1);}
	return str;
	}



function StartSilverjuke()
// nach Start von Silverjuke ausführen
	{
	NowPlayingOff();

    program.addSkinsButton("Now Playing Configuration", ConfigEdit);


    ConfigRead();

    if (config_showmsg == 1)
    {
        ConfigEdit();
    }


	}

function Exit()
{
     // only used as dummy function to unload the timer
}

function ConfigRead()
{
    config_idletime = program.iniRead(configname + "/idletime", "60");
    config_showmsg = program.iniRead(configname + "/showmsg", "1");
}


function ConfigEdit()
{
    var dlg = new Dialog();

    dlg.addStaticText("Now Playing "  + " configuration\n");

    dlg.addTextCtrl("ididletime", "Trackinfo screen timeout (seconds)", config_idletime);

    dlg.addStaticText("");
    dlg.addSelectCtrl("idshowmsg", "Show this dialog on startup", config_showmsg, "No", "Yes");
    dlg.addStaticText("(if disabled this dialog can be reached by doubleclicking\nthis skin on the 'Settings->Skins' page)");

    if (dlg.showModal() == "ok")
    {
        program.iniWrite(configname + "/idletime", dlg.getValue("ididletime"));
        program.iniWrite(configname + "/showmsg", dlg.getValue("idshowmsg"));

        ConfigRead();
    };
}

function fastbw()
	{
	player.time -= 10000;
	}

function fastfw()
	{
	player.time += 10000;
	}





	
function shufflePlaylist()
// Shuffle Playlist Skript von Skinner
	{
	// eine kleine Nachricht (dies beschleunigt auch shufling, denn es gibt keine Notwendigkeit, die Anzeige zu aktualisieren)
	program.setDisplayMsg("Wiedergabeliste mischen ...");

	// alle wartenden Tracks merken
	var waitingUrls = new Array(), i;
	for( i = 0; i < player.queueLength; i++ )
		{	
		if( (player.queuePos != i) && (player.getPlayCountAtPos(i) == 0) )
			{
			waitingUrls.push(player.getUrlAtPos(i));
			}
		}

	// entfernt alle außer den spielenden Titel
	while( player.queuePos > 0 ) player.removeAtPos(0);
	while( player.queueLength > 1 ) player.removeAtPos(player.queueLength-1);

	// fügt wieder alle Tracks in zufälliger Reihenfolge ein
	while( waitingUrls.length > 0 )
		{
		i = parseInt(Math.random() * waitingUrls.length);
		player.addAtPos(-1, waitingUrls.splice(i, 1));
		}

	// löschen der Nachricht
	if( program.selectAll )
		{
		program.selectAll(false);
		}
	program.setDisplayMsg("Wiedergabeliste mischen ...", 1);
	}

	
	
	player.onTrackChange = ScreenUpdate;


function Rated() 
{ 
program.musicSel = "Rated"; 
program.setDisplayMsg('Rated selected', 1000); 
} 




function setRating0()
	{
	url = player.getUrlAtPos();
	if (url != "") 
	var db = new Database();
	var quoteExpr = new RegExp("'", "g");
	db.openQuery("update tracks set rating=0 where url ='"+url.replace(quoteExpr,"''")+"';");
	db.closeQuery();
	program.refreshWindows();
	program.setDisplayMsg ('Rating set to 0',1000);
	ScreenUpdate();
	}

function setRating1()
	{
	url = player.getUrlAtPos();
	var db = new Database();
	var quoteExpr = new RegExp("'", "g");
	db.openQuery("update tracks set rating=1 where url ='"+url.replace(quoteExpr,"''")+"';");
	db.closeQuery();
	program.refreshWindows();
	program.setDisplayMsg("Rating set to '*'",1000);
	ScreenUpdate();
	}

function setRating2()
	{
	url = player.getUrlAtPos();
	var db = new Database();
	var quoteExpr = new RegExp("'", "g");
	db.openQuery("update tracks set rating=2 where url ='"+url.replace(quoteExpr,"''")+"';");
	db.closeQuery();
	program.refreshWindows();
	program.setDisplayMsg("Rating set to '**'",1000);
	ScreenUpdate();
	}

function setRating3()
	{
	url = player.getUrlAtPos();
	var db = new Database();
	var quoteExpr = new RegExp("'", "g");
	db.openQuery("update tracks set rating=3 where url ='"+url.replace(quoteExpr,"''")+"';");
	db.closeQuery();
	program.refreshWindows();
	program.setDisplayMsg("Rating set to '***'",1000);
	ScreenUpdate()
	}

function setRating4()
	{
	url = player.getUrlAtPos();
	var db = new Database();
	var quoteExpr = new RegExp("'", "g");
	db.openQuery("update tracks set rating=4 where url ='"+url.replace(quoteExpr,"''")+"';");
	db.closeQuery();
	program.refreshWindows();
	program.setDisplayMsg("Rating set to '****'",1000);
	ScreenUpdate();
	}

function setRating5()
	{
	url = player.getUrlAtPos();
	var db = new Database();
	var quoteExpr = new RegExp("'", "g");
	db.openQuery("update tracks set rating=5 where url ='"+url.replace(quoteExpr,"''")+"';");
	db.closeQuery();
	program.refreshWindows();
	program.setDisplayMsg("Rating set to '*****'",1000);
	ScreenUpdate();
	}
	
