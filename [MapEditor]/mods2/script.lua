	col1 = engineLoadCOL('wall006.col')
	dff1 = engineLoadDFF('wall006.dff', 0)
	txd1 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd1,3063)            
        engineReplaceCOL(col1, 3063)           
	engineReplaceModel(dff1, 3063)

	col2 = engineLoadCOL('wall018.col')
	dff2 = engineLoadDFF('wall018.dff', 0)
	txd2 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd2,3097)
        engineReplaceCOL(col2, 3097)
	engineReplaceModel(dff2, 3097)

	col3 = engineLoadCOL('wall019.col')
	dff3 = engineLoadDFF('wall019.dff', 0)
	txd3 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd3,10252)
        engineReplaceCOL(col3, 10252)
	engineReplaceModel(dff3, 10252)

	col4 = engineLoadCOL('wall036.col')
	dff4 = engineLoadDFF('wall036.dff', 0)
	txd4 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd4,3099)
        engineReplaceCOL(col4, 3099)
	engineReplaceModel(dff4, 3099)

	col5 = engineLoadCOL('wall052.col')
	dff5 = engineLoadDFF('wall052.dff', 0)
	txd5 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd5,3098)
        engineReplaceCOL(col5, 3098)
	engineReplaceModel(dff5, 3098)

	col6 = engineLoadCOL('wall090.col')
	dff6 = engineLoadDFF('wall090.dff', 0)
	txd6 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd6,3064)
        engineReplaceCOL(col6, 3064)
	engineReplaceModel(dff6, 3064)

	col7 = engineLoadCOL('wall102.col')
	dff7 = engineLoadDFF('wall102.dff', 0)
	txd7 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd7,7922)
        engineReplaceCOL(col7, 7922)
	engineReplaceModel(dff7, 7922)

        dff = engineLoadDFF ('wall071.dff', 0)
        col = engineLoadCOL ('wall071.col')
        txd = engineLoadTXD ('All_walls.txd')
        engineImportTXD(txd, 3898)
        engineReplaceCOL(col, 3898)
        engineReplaceModel(dff, 3898)

	col8 = engineLoadCOL('lsmall_shop01.col')
	dff8 = engineLoadDFF('lsmall_shop01.dff', 0)
	txd8 = engineLoadTXD('lsmall_shops.txd')
        engineImportTXD(txd8,2957)            
        engineReplaceCOL(col8, 2957)           
	engineReplaceModel(dff8, 2957)


	col9 = engineLoadCOL('lsmall_window01.col')
	dff9 = engineLoadDFF('lsmall_window01.dff', 0)
	txd9 = engineLoadTXD('lsmall_shops.txd')
        engineImportTXD(txd9,3900)
        engineReplaceCOL(col9, 3900)
	engineReplaceModel(dff9, 3900)

	col10 = engineLoadCOL('mallb_laW02.col')
	dff10 = engineLoadDFF('mallb_law02.dff', 0)
	txd10 = engineLoadTXD('mall_law.txd')
        engineImportTXD(txd10,6130)
        engineReplaceCOL(col10, 6130)
	engineReplaceModel(dff10, 6130)
	
		col11 = engineLoadCOL('wall041.col')
	dff11 = engineLoadDFF('wall041.dff', 0)
	txd11 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd11,3917)
        engineReplaceCOL(col11, 3917)
	engineReplaceModel(dff11, 3917)

        dff12 = engineLoadDFF ('wall012.dff', 0)
        col12 = engineLoadCOL ('wall012.col')
        txd12 = engineLoadTXD ('All_walls.txd')
        engineImportTXD(txd12, 3911)
        engineReplaceCOL(col12, 3911)
        engineReplaceModel(dff12, 3911)

	col13 = engineLoadCOL('wall058.col')
	dff13 = engineLoadDFF('wall058.dff', 0)
	txd13 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd13,3907)            
        engineReplaceCOL(col13, 3907)           
	engineReplaceModel(dff13, 3907)


	col14 = engineLoadCOL('wall077.col')
	dff14 = engineLoadDFF('wall077.dff', 0)
	txd14 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd14,3906)
        engineReplaceCOL(col14, 3906)
	engineReplaceModel(dff14, 3906)

	col15 = engineLoadCOL('wall096.col')
	dff15 = engineLoadDFF('wall096.dff', 0)
	txd15 = engineLoadTXD('All_walls.txd')
        engineImportTXD(txd15,3905)
        engineReplaceCOL(col15, 3905)
	engineReplaceModel(dff15, 3905)
	
	dff55 = engineLoadDFF ( "hospital_law.dff", 0 )
engineReplaceModel ( dff55, 5708 )
col55 = engineLoadCOL ( "hospitalos.col")
engineReplaceCOL ( col55, 5708 )

col56 = engineLoadCOL ( "streetbugfix.col")
 engineReplaceCOL ( col56, 5808 )
 
 dff58 = engineLoadDFF('f-s.dff', 0)
 engineReplaceModel(dff58, 5810)
         col58 = engineLoadCOL('fs.col')
 engineReplaceCOL(col58, 5810)