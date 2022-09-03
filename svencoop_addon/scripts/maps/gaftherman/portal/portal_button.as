class portal_button : ScriptBaseEntity
{
    private bool Inside = false;

	void Spawn()
	{
        Precache();
		self.pev.movetype = MOVETYPE_NONE;
		self.pev.solid = SOLID_NOT;

		g_EntityFuncs.SetOrigin(self, self.pev.origin);
		g_EntityFuncs.SetModel(self, "models/mikk/portal/button_base.mdl");

		dictionary dicButtonTop;
        dicButtonTop ["model"] = "models/mikk/portal/button_top.mdl";
		dicButtonTop ["origin"] = self.GetOrigin().ToString();
		dicButtonTop ["angles"] = self.pev.angles.ToString();

        g_EntityFuncs.CreateEntity("item_generic", dicButtonTop, true);
    }

    void Precache()
    {
        g_Game.PrecacheModel( "models/mikk/portal/button_base.mdl" );
        g_Game.PrecacheGeneric( "models/mikk/portal/button_base.mdl" );

        g_Game.PrecacheModel( "models/mikk/portal/button_top.mdl" );
        g_Game.PrecacheGeneric( "models/mikk/portal/button_top.mdl" );
    }

    void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue = 0.0f)
    {
        switch(useType)
        {
            case USE_ON:
            {
                self.pev.spawnflags &= ~1;
                break;
            }

            case USE_OFF:
            {
                self.pev.spawnflags |= 1;
                break;
            }

            case USE_TOGGLE:
            {	
                self.Use(pActivator, pCaller, self.pev.SpawnFlagBitSet(1) ? USE_ON : USE_OFF, flValue);
                break;
            }
        }
    }

    void Think()
    {
        if(!self.pev.SpawnFlagBitSet(1) && self.pev.netname != "" ) 
        {
            CBaseEntity@ pEntity = null;
            while((@pEntity = g_EntityFuncs.FindEntityByTargetname( pEntity, self.pev.netname )) !is null)
            {
                if(!Inside)
                {
                    if((self.pev.origin - pEntity.pev.origin).Length() <= self.pev.frags)
                    {
                        self.SUB_UseTargets(self, USE_TOGGLE, 0.0f);
                    }
                    else
                    {
                        self.SUB_UseTargets(self, USE_TOGGLE, 0.0f);
                    }
                }
            }
        }
        self.pev.nextthink = g_Engine.time + 0.1f;
    }
}

void RegisterPortalButton() 
{
	g_CustomEntityFuncs.RegisterCustomEntity( 'portal_button', 'portal_button' );
    g_Game.PrecacheOther( 'portal_button' );
}