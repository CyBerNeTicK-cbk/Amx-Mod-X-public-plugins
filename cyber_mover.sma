/*
*
*
* * * ***** ***** * ***** * * ***** * * * *
* * * * * * * * * * ** * * ** * * * *
* ****** ****** ****** * * ****** * * * * * * * * * * *
* * * * * ******* * * * * * * * * * * * *
* * * ***** ***** * * ***** * * ***** * * * *
*
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* AMX MOD X Script. *
* Plugin made by CyBer[N]eTicK *
  
  > ts.blackgames.ro
  > blackgames.ro/forum

* Important! You can modify the code, but DO NOT modify the author! *
* Contacts with me: *

* DISCORD: CyBer[N]eTicK#5615 - username cybernetick_cbk *
* STEAM: https://steamcommunity.com/id/cybernetick_cbk/ *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Special thanks to: *
* 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
*
*/


#include <amxmodx>
#include <amxmisc>
#include <cstrike>

#if AMXX_VERSION_NUM < 190
    #error "[ CYBER ] :: This plugin was developed using AMXX version 1.9, and it is only compatible with this specific version for compilation."
#endif


#define PLUGIN  "CYBER : Admin Mover"
#define VERSION "1.1"
#define AUTHOR  "CyBer[N]eTicK"

new g_iCvarPublicCommands;
new g_iCvarCommandImmunity;

#pragma semicolon 1

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	register_cvar("cyber_plugins", VERSION, FCVAR_SERVER | FCVAR_SPONLY);


	register_concmd("amx_t", "cmdAdminMove", ADMIN_KICK, "<name>");
	register_concmd("amx_ct", "cmdAdminMove", ADMIN_KICK, "<name>");
	register_concmd("amx_spec", "cmdAdminMove", ADMIN_KICK, "<name>");

	g_iCvarPublicCommands 	= register_cvar("amx_public_movecmd", "1");
	g_iCvarCommandImmunity	= register_cvar("amx_immunity_movecmd", "1");

	register_clcmd("say", "cmdPlayerMove");
	register_clcmd("say_team", "cmdPlayerMove");

	set_task(120.0, "eventMSG",_,_,_, "b");
}

public eventMSG()
{
	ChatColor(0, "^4[Commands] ^3Available commands for changing teams:^4 -> /ct -> /t -> /spec");
}

public cmdPlayerMove(client) {
	if(get_pcvar_num(g_iCvarPublicCommands) != 1)
		return;

	new szArgs[192];

	read_args(szArgs, charsmax(szArgs));
	remove_quotes(szArgs);

	if(equal(szArgs, "/t", 2)) {
		if(IsPlayerInTeam(client, 1) || is_user_alive(client)) return;
		user_silentkill(client);
		cs_set_user_team(client, CS_TEAM_T);
	} else if(equal(szArgs, "/ct", 3)) {
		if(IsPlayerInTeam(client, 2) || is_user_alive(client)) return;
		user_silentkill(client);
		cs_set_user_team(client, CS_TEAM_CT);
	} else if(equal(szArgs, "/spec", 5)) {
		if(IsPlayerInTeam(client, 3) || is_user_alive(client)) return;
		user_silentkill(client);
		cs_set_user_team(client, CS_TEAM_SPECTATOR);
	}
}



public cmdAdminMove(client, level, cid) {
	if (!cmd_access(client, level, cid, 2)) 
		return 1;

	new iTeam[16];	
	new iTarget[32];
	new iPlayer;

	read_argv(0, iTeam, charsmax(iTeam));
	read_argv(1, iTarget, charsmax(iTarget));

	if (get_pcvar_num(g_iCvarCommandImmunity) == 1) {
    	iPlayer = cmd_target(client, iTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_NO_BOTS | CMDTARGET_ALLOW_SELF);
	} else if (get_pcvar_num(g_iCvarCommandImmunity) == 2) {
	    iPlayer = cmd_target(client, iTarget, (1 << 0) | (1 << 1) | (1 << 3));
	} else {
	    iPlayer = cmd_target(client, iTarget, CMDTARGET_OBEY_IMMUNITY | CMDTARGET_NO_BOTS | CMDTARGET_ALLOW_SELF);
	}
		
	if (!iPlayer) 
		return 1;

	if (equal(iTeam, "amx_t", 5)) 
	{
		if(IsPlayerInTeam(iPlayer, 1)) 
		{
			console_print(client, "Player %s is already on the Terrorists team.", get_name(iPlayer));
			return 1;
		}
		user_silentkill(iPlayer);
		cs_set_user_team(iPlayer, CS_TEAM_T);
		log_amx("Administrator [%s] transferred [%s] to the Terrorists team.", get_name(client), get_name(iPlayer));
		ChatColor(0, "^3Administrator: ^4%s ^3moved the player: ^4%s ^3to the Terrorist team.", get_name(client), get_name(iPlayer));
	} else if (equal(iTeam, "amx_ct", 6)) 
	{
		if(IsPlayerInTeam(iPlayer, 2)) 
		{
			console_print(client, "Player %s is already on the Counter-Terrorists team.", get_name(iPlayer));
			return 1;
		}
		user_silentkill(iPlayer);
		cs_set_user_team(iPlayer, CS_TEAM_CT);
		log_amx("Administrator [%s] transferred [%s] to the Counter-Terrorists team.", get_name(client), get_name(iPlayer));
		ChatColor(0, "^3Administrator: ^4%s ^3moved the player: ^4%s ^3to the Counter-Terrorist team.", get_name(client), get_name(iPlayer));
	} 
	else if (equal(iTeam, "amx_spec", 8)) 
	{
		if(IsPlayerInTeam(iPlayer, 3)) 
		{
			console_print(client, "Player %s is already on the Spectators team.", get_name(iPlayer));
			return 1;
		}
		user_silentkill(iPlayer);
		cs_set_user_team(iPlayer, CS_TEAM_SPECTATOR);
		log_amx("Administrator [%s] transferred [%s] to the Spectators team.", get_name(client), get_name(iPlayer));
		ChatColor(0, "^3Administrator:^4 %s ^3moved the player:^4 %s ^3to the Spectator team.", get_name(client), get_name(iPlayer));
	} 
	else {}

	return 1;
}


////////////////////// STOCK //////////////////////
stock IsPlayerInTeam(playerIndex, team) {
    new currentTeam = get_user_team(playerIndex);
    return currentTeam == team;
}
////////////////////// STOCK //////////////////////
stock get_name(index)
{
    new szName[32];
    get_user_name(index, szName, charsmax(szName));
    return szName;
}
////////////////////// STOCK //////////////////////
stock ChatColor(const id, const input[], any:...) 
{ 
new count = 1, players[32]; 
static msg[191]; 
vformat(msg, 190, input, 3); 

replace_all(msg, 190, "!g", "^4"); 
replace_all(msg, 190, "!y", "^1"); 
replace_all(msg, 190, "!team", "^3"); 

if (id) players[0] = id; else get_players(players, count, "ch"); 
{ 
for (new i = 0; i < count; i++) 
{ 
if (is_user_connected(players[i])) 
{ 
message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i]); 
write_byte(players[i]); 
write_string(msg); 
message_end(); 
} 
} 
} 
}
