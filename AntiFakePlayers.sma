/*============================================================*/
/*                     AmX Mod X                              */
/*============================================================*/
/*                                                            */
/* This is an AMX Mod X script for CS 1.6                     */
/* Created by: CyBer[N]eTicK                                   */
/* Github: https://github.com/CyBerNeTicK-cbk/                */
/* Contact:                                                   */
/*   - Steam: [https://steamcommunity.com/id/cybernetick_cbk] */
/*   - Discord: [cybernetick_cbk]                             */   
/*   - Signal: cybernetick.01                                 */  
/* Website: blackgames.ro                                     */
/*                                                            */
/* Disclaimer:                                                */
/*   - Do not modify the author information                   */
/*   - Any reposting on other blogs or websites               */
/*     must be done only with my permission or                */
/*     the permission of those who contributed                */
/*                                                            */
/*============================================================*/
// Contributors: 

//============================================================



/*------------------------------------------------------------
 Includes                                                   
------------------------------------------------------------*/
#include <amxmodx>    


/*------------------------------------------------------------*/
/* Plugin Information                                         */
/*------------------------------------------------------------*/
#define PLUGIN  "CYBER Plugin || Anti Fake Players"  
#define VERSION "1.1"          
#define AUTHOR  "CyBer[N]eTicK"      



public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    register_cvar("cyber_plugins", VERSION, FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED)

    set_task(10.0, "TaskCheck",_,_,_, "b")
}


public TaskCheck()
{
    new iPlayers[MAX_PLAYERS], nNum;
    new szAuthid[31], szIP[15];

    get_players(iPlayers, nNum);
    for(new i = 0; i < nNum; i++)
    {
        new client = iPlayers[i];

        if(!is_user_connected(client)) continue;

        get_user_authid(client, szAuthid, sizeof(szAuthid));
        get_user_ip(client, szIP, sizeof(szIP) - 1);

        if (CheckMultipleConnections(szIP, szAuthid))
        {
            KickAllWithSameIP(szIP);
            KickAllWithSameAuthID(szAuthid);
        }
    }
}

bool: CheckMultipleConnections(const szIP[], const szAuthid[])
{
    new iPlayers[MAX_PLAYERS], nNum;
    new ipCount = 0, authidCount = 0;
    new szTempAuthid[31], szTempIP[15];

    get_players(iPlayers, nNum);
    for(new i = 0; i < nNum; i++)
    {
        new client = iPlayers[i];
        
        if(!is_user_connected(client)) continue;

        get_user_authid(client, szTempAuthid, sizeof(szTempAuthid));
        get_user_ip(client, szTempIP, sizeof(szTempIP) - 1);

        if(equal(szIP, szTempIP)) ipCount++;
        if(equal(szAuthid, szTempAuthid)) authidCount++;

        if (ipCount > 1 || authidCount > 1)
        {
            return true;
        }
    }

    return false;
}

stock KickAllWithSameIP(const szIP[])
{
    new iPlayers[MAX_PLAYERS], nNum;
    new szTempIP[15];

    get_players(iPlayers, nNum);
    for(new i = 0; i < nNum; i++)
    {
        new client = iPlayers[i];
        
        if(!is_user_connected(client)) continue;

        get_user_ip(client, szTempIP, sizeof(szTempIP) - 1);

        if(equal(szIP, szTempIP))
        {
            server_cmd("kick #%d Duplicate IP detected", get_user_userid(client));
            // or addip
        }
    }
}

stock KickAllWithSameAuthID(const szAuthid[])
{
    new iPlayers[MAX_PLAYERS], nNum;
    new szTempAuthid[31];

    get_players(iPlayers, nNum);
    for(new i = 0; i < nNum; i++)
    {
        new client = iPlayers[i];
        
        if(!is_user_connected(client)) continue;

        get_user_authid(client, szTempAuthid, sizeof(szTempAuthid));

        if(equal(szAuthid, szTempAuthid))
        {
            server_cmd("kick #%d Duplicate SteamID detected", get_user_userid(client));
            // or addip
        }
    }
}
