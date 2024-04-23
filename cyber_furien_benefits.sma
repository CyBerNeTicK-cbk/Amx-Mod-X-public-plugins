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
#include <fun>
#include <cstrike>


#if AMXX_VERSION_NUM < 190
    #error "[ CYBER ] :: This plugin was developed using AMXX version 1.9, and it is only compatible with this specific version for compilation."
#endif


#define PLGUIN " CYBER :: Furien beneficii"
#define VERSION "1.2"

// Steam DIAMOND Beneficii 
new const g_dAuthid[]	=
{
	"",
	""
};
// Steam GOLD Beneficii 
new const g_gAuthid[]	=
{
	"",
	""
};

// Steam ELITE Beneficii 
new const g_eAuthid[]	=
{
	"",
	""
};

// Steam SILVER Beneficii 
new const g_sAuthid[]	=
{
	"",
	""
};
// Steam VIP Beneficii 
new const g_vAuthid[]	=
{
	"",
	""
};



// Diamond
#define D_PLAYER_HEALTH 60 
#define D_PLAYER_ARMOR 	60
#define D_PLAYER_MONEY  6000

// VIP
#define V_PLAYER_HEALTH 50 
#define V_PLAYER_ARMOR 	50
#define V_PLAYER_MONEY  5000

// GOLD
#define G_PLAYER_HEALTH 50 
#define G_PLAYER_ARMOR 	50
#define G_PLAYER_MONEY  5000

// ELITE
#define E_PLAYER_HEALTH 40 
#define E_PLAYER_ARMOR 	40
#define E_PLAYER_MONEY  4000

// SILVER
#define S_PLAYER_HEALTH 30 
#define S_PLAYER_ARMOR 	30
#define S_PLAYER_MONEY  3000


public plugin_init()
{
	register_plugin(PLGUIN, VERSION, "CyBer[N]eTicK");
	register_cvar("furien_cyber", VERSION, FCVAR_SERVER || FCVAR_SPONLY);

	register_event("DeathMsg", "ev_DeathMsg", "a");
}


public ev_DeathMsg()
{
	new iKiller = read_data(1);
	new iVictim = read_data(2);

	if(!is_user_alive(iKiller) || !is_user_connected(iVictim) || !is_user_connected(iKiller)) 
        return; 

   	if(iKiller == iVictim) 
        return;

   	if(isPlayerAuthid(iKiller, g_dAuthid, sizeof(g_dAuthid)))
	{
	    set_user_health(iKiller, min(250, get_user_health(iKiller) + D_PLAYER_HEALTH));
	    set_user_armor(iKiller, min(250, get_user_armor(iKiller) + D_PLAYER_ARMOR));
	    cs_set_user_money(iKiller, min(16000, cs_get_user_money(iKiller) + D_PLAYER_MONEY));
	}
	else if(isPlayerAuthid(iKiller, g_vAuthid, sizeof(g_vAuthid)))
	{
	    set_user_health(iKiller, min(250, get_user_health(iKiller) + V_PLAYER_HEALTH));
	    set_user_armor(iKiller, min(250, get_user_armor(iKiller) + V_PLAYER_ARMOR));
	    cs_set_user_money(iKiller, min(16000, cs_get_user_money(iKiller) + V_PLAYER_MONEY));
	}
	else if(isPlayerAuthid(iKiller, g_gAuthid, sizeof(g_gAuthid)))
	{
	    set_user_health(iKiller, min(250, get_user_health(iKiller) + G_PLAYER_HEALTH));
	    set_user_armor(iKiller, min(250, get_user_armor(iKiller) + G_PLAYER_ARMOR));
	    cs_set_user_money(iKiller, min(16000, cs_get_user_money(iKiller) + G_PLAYER_MONEY));
	}
	else if(isPlayerAuthid(iKiller, g_eAuthid, sizeof(g_eAuthid)))
	{
	    set_user_health(iKiller, min(250, get_user_health(iKiller) + E_PLAYER_HEALTH));
	    set_user_armor(iKiller, min(250, get_user_armor(iKiller) + E_PLAYER_ARMOR));
	    cs_set_user_money(iKiller, min(16000, cs_get_user_money(iKiller) + E_PLAYER_MONEY));
	}
	else if(isPlayerAuthid(iKiller, g_sAuthid, sizeof(g_sAuthid)))
	{
	    set_user_health(iKiller, min(250, get_user_health(iKiller) + S_PLAYER_HEALTH));
	    set_user_armor(iKiller, min(250, get_user_armor(iKiller) + S_PLAYER_ARMOR));
	    cs_set_user_money(iKiller, min(16000, cs_get_user_money(iKiller) + S_PLAYER_MONEY));
	}
}

////////////////////// STOCK //////////////////////
stock isPlayerAuthid(id, const authid_array[], arraySize)
{
    new szAuthid[64]; 
    get_user_authid(id, szAuthid, 63);

    for(new i = 0; i < arraySize; i++)
    {
        if(equali(szAuthid, authid_array[i]))
        {
            return true;
        }
    }
    return false;
}
