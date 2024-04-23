/*
////////////////////// VERSION UPDATES ////////////////////////
1.0 - Pluginul de rase
1.1 - Adaugat modele player, la fiecare race. 
1.2 - Adaugat modele pe knife, la fiecare race.
1.3 - S-a restabilit pluginul, reparat speed-ul. 

Plugin Author = CyBer[N]eTicK 
(Aragon) - gloante infinite
Askhanar - modele
Link oficial - https://blackgames.ro/forum/index.php?/topic/20298-cerere-plugin-rase/&tab=comments#comment-57658

*/


#include < amxmodx > 
#include < amxmisc > 
#include < cstrike > 
#include < fakemeta > 
#include < engine > 
#include < fakemeta_util > 
#include < fun > 
#include < hamsandwich > 

#pragma semicolon 1

new const 
	PLUGIN_NUME[]		=	"Base Builder: Human Race",
	PLUGIN_VERSIUNE[]	=	"1.3";
	
new
		Sarituri,
		GlInf[33],
		ReloadTime[33],
		bool: SpeedRace[33],
		bool: KnifeSz1[33],
		bool: KnifeSz2[33],
		bool: KnifeSz3[33];
new jumpznum[33] = 0;
new bool:dozjump[33] = false;

// Player Model
new const ModeleRace[4][]=
{
	"",
	"PLAYER",
	"ADMIN",
	"VIP"
};
// Knifes
new const
	KnifeXz1[66]	=	"models/race_1.mdl",
	KnifeXz2[66]	=	"models/race_2.mdl",
	KnifeXz3[66]	=	"models/race_3.mdl";

public plugin_init(){
	register_plugin(PLUGIN_NUME, PLUGIN_VERSIUNE, "CyBer[N]eTicK");
	register_cvar("cyber_plugins", PLUGIN_VERSIUNE, FCVAR_SERVER || FCVAR_SPONLY);
	
	// Comenzile de accesare. 
	register_clcmd("say /race", "CmdRace");
	register_clcmd("say_team /race", "CmdRace");
	register_clcmd("say /rasa", "CmdRace");
	//
	RegisterHam(  Ham_Spawn,  "player",  "PosPlayerSpawn",  true  );
	register_event("CurWeapon","event_curweapon","be","1=1");
	
	Sarituri = register_cvar("vip_race_xjump","2");		
}
public plugin_precache()
{
	new XYZ[66];
	for(new i = 1; i < 4; i++)
	{
	formatex(XYZ, sizeof(XYZ) -1, "models/player/%s/%s.mdl", ModeleRace[i], ModeleRace[i] );
	precache_model(XYZ);
	}
	precache_model(KnifeXz1);
	precache_model(KnifeXz2);
	precache_model(KnifeXz3);
}

public CmdRace(id){
	if(is_user_alive(id) && get_user_team(id) == 2){
		new menu = menu_create("Alege-ti rasa CT", "GiveRace");
		
		menu_additem(menu, "\rPLAYER \w- M4A1 | VITEZA", "1", 0);
		menu_additem(menu, "\rADMIN \w-  AK47 | VITEZA | GRAVITATIE ", "2", 0);
		menu_additem(menu, "\rVIP \w- ALL WEAPONS | ALL POWERS | \rGloante Infinite \w| \yX2 Jump", "3", 0);
		
		menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
		menu_display(id, menu, 0);
	}
}
public GiveRace( id, menu, item ) { 
    
    if( item == MENU_EXIT ) 
    {
        return 1;
    }
    new data [ 6 ], szName [ 64 ]; 
    new access, callback; 
    menu_item_getinfo ( menu, item, access, data,charsmax ( data ), szName,charsmax ( szName ), callback ); 
    new key = str_to_num ( data ); 
    if(is_user_alive(id) && get_user_team(id) == 2)
    switch ( key ) 
    {
    	case 1:
	{
		give_item(id, "weapon_m4a1");
		give_item(id, "weapon_usp");
		cs_set_user_bpammo(id, CSW_M4A1, 999);
		cs_set_user_bpammo(id, CSW_USP, 999);
		SpeedRace[id] = true;
		KnifeSz1[id] = true;
		cs_set_user_model(id, ModeleRace[1]);
		
	}
	case 2:{
		if(get_user_flags(id) & ADMIN_KICK){
		give_item(id, "weapon_ak47");
		give_item(id, "weapon_deagle");
		cs_set_user_bpammo(id, CSW_AK47, 999);
		cs_set_user_bpammo(id, CSW_DEAGLE, 999);
		set_user_gravity(id, 0.5);
		SpeedRace[id] = true;
		KnifeSz2[id] = true;
		cs_set_user_model(id, ModeleRace[2]);
		}
		else{CmdRace(id); return 1;}}
	case 3:{
		if(get_user_flags(id) & ADMIN_LEVEL_H){
		give_item(id, "weapon_m4a1");
		give_item(id, "weapon_usp");
		give_item(id, "weapon_ak47");
		give_item(id, "weapon_deagle");
		cs_set_user_bpammo(id, CSW_M4A1, 999);
		cs_set_user_bpammo(id, CSW_USP, 999);
		cs_set_user_bpammo(id, CSW_AK47, 999);
		cs_set_user_bpammo(id, CSW_DEAGLE, 999);
		set_user_gravity(id, 0.5);
		SpeedRace[id] = true;
		KnifeSz3[id] = true;
		GlInf[id] = 1;
		cs_set_user_model(id, ModeleRace[3]);
		}
		else{CmdRace(id); return 1;}
	}
   }
    menu_destroy ( menu ); 
    return PLUGIN_HANDLED;
    
} 
public PosPlayerSpawn(id){
	CmdRace(id);
	SpeedRace[id] = false;
	KnifeSz1[id] = false;
	KnifeSz2[id] = false;
	KnifeSz3[id] = false;
}
public event_curweapon(id){
	if(get_user_team(id) == 2)
	{
	new wpnid = read_data(2);
	new clip = read_data(3);
	
	if(GlInf[id] == 1){ 
	if (wpnid == CSW_C4 || wpnid == CSW_KNIFE) {}
	if (wpnid == CSW_HEGRENADE || wpnid == CSW_SMOKEGRENADE || wpnid == CSW_FLASHBANG) {}
	if (clip == 0) reloadAmmo(id);
		}
	if(SpeedRace[id])
	set_user_maxspeed(id, 350.0);
	}
	new Model = read_data(2);
	if(Model == CSW_KNIFE && KnifeSz1[id]){set_pev( id, pev_viewmodel2, KnifeXz1 );}
	if(Model == CSW_KNIFE && KnifeSz2[id]){set_pev( id, pev_viewmodel2, KnifeXz2 );}
	if(Model == CSW_KNIFE && KnifeSz3[id]){set_pev( id, pev_viewmodel2, KnifeXz3 );}
	
}
public reloadAmmo(id) {
	if (!is_user_connected(id)) return;
	if (ReloadTime[id] >= get_systime() - 1) return;
	ReloadTime[id] = get_systime();
	
	new clip, ammo, wpn[32];
	new wpnid = get_user_weapon(id, clip, ammo);
	
	if (wpnid == CSW_C4 || wpnid == CSW_KNIFE || wpnid == 0) return;
	if (wpnid == CSW_HEGRENADE || wpnid == CSW_SMOKEGRENADE || wpnid == CSW_FLASHBANG) return;
	
	if (clip == 0) {
	get_weaponname(wpnid,wpn,31);
	new iWPNidx = -1;
	while((iWPNidx = fm_find_ent_by_class(iWPNidx, wpn)) != 0) {
	if(id == pev(iWPNidx, pev_owner)) {
	cs_set_weapon_ammo(iWPNidx, getMaxClipAmmo(wpnid));
	break;
}
}
}
}
stock getMaxClipAmmo(wpnid) {
	new clipammo = 0;
	switch (wpnid) {
	case CSW_P228 : clipammo = 13;
	case CSW_SCOUT : clipammo = 10;
	case CSW_HEGRENADE : clipammo = 0;
	case CSW_XM1014 : clipammo = 7;
	case CSW_C4 : clipammo = 0;
	case CSW_MAC10 : clipammo = 30;
	case CSW_AUG : clipammo = 30;
	case CSW_SMOKEGRENADE : clipammo = 0;
	case CSW_ELITE : clipammo = 15;
	case CSW_FIVESEVEN : clipammo = 20;
	case CSW_UMP45 : clipammo = 25;
	case CSW_SG550 : clipammo = 30;
	case CSW_GALI : clipammo = 35;
	case CSW_FAMAS : clipammo = 25;
	case CSW_USP : clipammo = 12;
	case CSW_GLOCK18 : clipammo = 20;
	case CSW_AWP : clipammo = 10;
	case CSW_MP5NAVY : clipammo = 30;
	case CSW_M249 : clipammo = 100;
	case CSW_M3 : clipammo = 8;
	case CSW_M4A1 : clipammo = 30;
	case CSW_TMP : clipammo = 30;
	case CSW_G3SG1 : clipammo = 20;
	case CSW_FLASHBANG : clipammo = 0;
	case CSW_DEAGLE : clipammo = 7;
	case CSW_SG552 : clipammo = 30;
	case CSW_AK47 : clipammo = 30;
	case CSW_KNIFE : clipammo = 0;
	case CSW_P90 : clipammo = 50;
	}
	return clipammo;
}
public client_putinserver(id){
	GlInf[id] = 0;
}
public client_disconnected(id){
	GlInf[id] = 0;
	dozjump[id] = false;	
	SpeedRace[id] = false;
	KnifeSz1[id] = false;
	KnifeSz2[id] = false;
	KnifeSz3[id] = false;
}
public client_connect(id){
	KnifeSz1[id] = false;
	KnifeSz2[id] = false;
	KnifeSz3[id] = false;
}

public client_PreThink(id) {
	if(!is_user_alive(id) || GlInf[id] != 1) return PLUGIN_CONTINUE;
    
	new nzbut = get_user_button(id);
	new ozbut = get_user_oldbutton(id);
	if((nzbut & IN_JUMP) && !(get_entity_flags(id) & FL_ONGROUND) && !(ozbut & IN_JUMP)) {
	if (jumpznum[id] < get_pcvar_num(Sarituri)) {
	dozjump[id] = true;
	jumpznum[id]++;
	return PLUGIN_CONTINUE;
	}
	}
	if((nzbut & IN_JUMP) && (get_entity_flags(id) & FL_ONGROUND)) {
	jumpznum[id] = 0;
	return PLUGIN_CONTINUE;
	}    
	return PLUGIN_CONTINUE;
	}

public client_PostThink(id) {
	if(!is_user_alive(id) || GlInf[id] != 1) return PLUGIN_CONTINUE;
    
	if(dozjump[id] == true) {
	new Float:vezlocityz[3];
	entity_get_vector(id,EV_VEC_velocity,vezlocityz);
	vezlocityz[2] = random_float(265.0,285.0);
	entity_set_vector(id,EV_VEC_velocity,vezlocityz);
	dozjump[id] = false;
	return PLUGIN_CONTINUE;
	}    
	return PLUGIN_CONTINUE;
}  
