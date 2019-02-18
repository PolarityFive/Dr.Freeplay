#include braxi\_dvar
init()
{
	addDvar( "freeplay", "dr_freeplay", 0, 0, 2, "int" );
	level.freeplay = GetDvarInt( "freeplay" );

	level.freeplaykey = "0";
	thread checkplayers();
	thread onPlayerConnected();
}

checkplayers()
{
	level endon ( "endmap" );
	level endon ( "game over" );
	
	for(;;)
	{
		temp = 0;
		pl = getentarray("player", "classname");
		for(i=0;i<pl.size;i++)	
			temp++;
		level.onserver = temp;
		wait .5;
		
		if(level.onserver == 1)
		{
			if(level.freeplay == 0)
			{
				setDvar( "dr_freerun_time", "600");
				setDvar( "freeplay", "1");
				map_restart( true );
			}
		}
		else if(level.onserver >= 2)
		{
			if(level.freeplay == 1)
			{
				setDvar( "dr_freerun_time", "60");
				setDvar( "freeplay", "0");
				map_restart( true );
			}
		}
		wait .5;
	}
}


onPlayerConnected()
{
	self endon("disconnect");
	
	for(;;)
	{
		level waittill("connected",player);
		player braxi\_common::clientCmd("bind "+level.freeplaykey +" openscriptmenu -1 freeplay");
		if(level.freeplay == 1)
		{
			player thread Nodify();
			player thread ToggleBinds();
		}
	}
}
ToggleBinds()
{
	self endon("disconnect");
	
	self thread Nodify();
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		if(response == "freeplay")
		{
			self iPrintlnbold("^1Ending Map!");
			wait 1;
			braxi\_mod::endMap( "Game Ended" );
		}
	}
}

Nodify()
{
	self endon("disconnect");
	
	for(;;)
	{
		wait RandomInt(60)+50;
		self iPrintln("^1 Free play. Waiting for players.");
		wait 3;
		self iPrintln("^2 Press "+level.freeplaykey +" to end the map and go to map vote.");
	}
}