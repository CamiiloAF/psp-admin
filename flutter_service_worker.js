'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "main.dart.js": "3a775babc83e68d83728cac480bcf014",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"manifest.json": "da11fb44df03bbcd099c256a0577dfcb",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"assets/NOTICES": "9b0fee992c16b3e2ab0f1fed7a471324",
"assets/packages/progress_dialog/assets/double_ring_loading_io.gif": "e5b006904226dc824fdb6b8027f7d930",
"assets/packages/country_code_picker/i18n/fr.json": "8a8c0f13bb50d940bbc1bb046dd360cf",
"assets/packages/country_code_picker/i18n/it.json": "346d53d5123fd692766a686887a75355",
"assets/packages/country_code_picker/i18n/es.json": "ccfbb564f963b9738e0ca6dcefa81286",
"assets/packages/country_code_picker/i18n/pt.json": "4a3aaf2f334359822f3d781045ad8606",
"assets/packages/country_code_picker/i18n/de.json": "d8b87bb657b9438677c4b08caf6cd52f",
"assets/packages/country_code_picker/i18n/en.json": "8fe204625d66a906988add1c4d372972",
"assets/packages/country_code_picker/flags/td.png": "3fbea92d2993d41e675e2c28fe56cc72",
"assets/packages/country_code_picker/flags/se.png": "b302900b3531cd2041f6970782fa4c9d",
"assets/packages/country_code_picker/flags/ly.png": "13275a10f191f039d917b62868466745",
"assets/packages/country_code_picker/flags/lt.png": "fe4b6768bea513692cd81c2a8cd07dd2",
"assets/packages/country_code_picker/flags/fi.png": "a725c5f466933b67ccdc1684d57aeb69",
"assets/packages/country_code_picker/flags/mq.png": "138388cea929cc0ea16c1fb680d0aecb",
"assets/packages/country_code_picker/flags/br.png": "3c1cc97fb7cb8972bae09b44e2fce4da",
"assets/packages/country_code_picker/flags/sk.png": "15beaa0665f2390b6aa6e59d91fbb0f1",
"assets/packages/country_code_picker/flags/to.png": "8337f8f32bb4a7520a64e081ee18f363",
"assets/packages/country_code_picker/flags/ga.png": "6baf0bb54e0c26b12a6bddcc0926674a",
"assets/packages/country_code_picker/flags/jo.png": "dc5bf015eaaeebe41bee6cc00cf088bb",
"assets/packages/country_code_picker/flags/pm.png": "031e5b6098f5ed49f23a2c9064f78ffe",
"assets/packages/country_code_picker/flags/ve.png": "cd978bd2a96018152810ba56d2132467",
"assets/packages/country_code_picker/flags/be.png": "53fbe587e3c6f08ecb002d26649f8294",
"assets/packages/country_code_picker/flags/tf.png": "400a6e309b5403a576ce51ce2ca67fba",
"assets/packages/country_code_picker/flags/af.png": "8e4a609a1539023fff0973983632c263",
"assets/packages/country_code_picker/flags/mk.png": "b4938c04e8d593cd8aec3fcd17fb49e0",
"assets/packages/country_code_picker/flags/nc.png": "611fa62f7400306a8a59c20044fb71fd",
"assets/packages/country_code_picker/flags/ws.png": "20401fa54faca7618a15d1f875c6a7b2",
"assets/packages/country_code_picker/flags/th.png": "6bfc2ec134e03314aa3332ff2300f483",
"assets/packages/country_code_picker/flags/so.png": "b0d1364d60af6993a82003b0caa5789b",
"assets/packages/country_code_picker/flags/mr.png": "0caa3e9cf697711f0fbb7bc2446ca00f",
"assets/packages/country_code_picker/flags/sc.png": "156e429aadb55e8aab18072cdb0e24fa",
"assets/packages/country_code_picker/flags/bt.png": "c29fbd07b36a40ca750ca3cbcba72f7c",
"assets/packages/country_code_picker/flags/mv.png": "3c52a0dd17378cefa19a0bed36d052d5",
"assets/packages/country_code_picker/flags/cy.png": "4ce8634dce05443bb2797385dbda9e88",
"assets/packages/country_code_picker/flags/no.png": "63b9529e994d70126338bf3d0ad1dfe9",
"assets/packages/country_code_picker/flags/mz.png": "de72bf5ab221e9675ad9e2cf3711e42b",
"assets/packages/country_code_picker/flags/fm.png": "49a33b328270b0330163f47330b05957",
"assets/packages/country_code_picker/flags/lk.png": "a2bfdc9d934cf5b5b6c831709fae4b14",
"assets/packages/country_code_picker/flags/gu.png": "60e1b7b4ef9280f9b72d0618a211272c",
"assets/packages/country_code_picker/flags/ie.png": "fb6c0b4ccc9094db555a0fe2168b3282",
"assets/packages/country_code_picker/flags/gd.png": "a38b53af2e2ff6664ce40c594cf724e2",
"assets/packages/country_code_picker/flags/im.png": "29852241be225005a3666868a004d83e",
"assets/packages/country_code_picker/flags/sl.png": "f8e7482ce1e959f879b7c8c0b03cb2a3",
"assets/packages/country_code_picker/flags/cg.png": "7fca0fedc965e9841f9d0fa9ff244f12",
"assets/packages/country_code_picker/flags/us.png": "701aeee5bf445569645edaa245b62bbe",
"assets/packages/country_code_picker/flags/np.png": "dd82d84262c291cbbf16ce034d59b72c",
"assets/packages/country_code_picker/flags/cu.png": "f3bdff8742c97bc8a40aaf93bd607170",
"assets/packages/country_code_picker/flags/bs.png": "bc192684d182b6619f7333ab729ab431",
"assets/packages/country_code_picker/flags/ax.png": "f24489906aca01cc03a4166d7f910d46",
"assets/packages/country_code_picker/flags/mf.png": "031e5b6098f5ed49f23a2c9064f78ffe",
"assets/packages/country_code_picker/flags/ee.png": "c8ab1e741657adf24d2f92363b0a1f1b",
"assets/packages/country_code_picker/flags/tk.png": "eaa766b422c20908dc50dc5546546b93",
"assets/packages/country_code_picker/flags/au.png": "74475c0254a3171ba9a72658853bc000",
"assets/packages/country_code_picker/flags/ug.png": "138c60be24f075ab7285aa30126fbf51",
"assets/packages/country_code_picker/flags/kn.png": "e533b6b646d22ff75e0dc4bba712fae0",
"assets/packages/country_code_picker/flags/sb.png": "ce8704d2edc449a4569043b7fe6d6d60",
"assets/packages/country_code_picker/flags/gt.png": "1c47bd94c40b81ba815a7de3c4b86c45",
"assets/packages/country_code_picker/flags/tz.png": "8a09e6c127fcb29b8098579e331a70ba",
"assets/packages/country_code_picker/flags/eg.png": "37744fb3daf61f0821bee15ca67e93d3",
"assets/packages/country_code_picker/flags/ck.png": "8e55bd2d062d72314c020db6a21aa4f7",
"assets/packages/country_code_picker/flags/an.png": "2d261a827037d3d7f37d0bed3fe7f0e6",
"assets/packages/country_code_picker/flags/dk.png": "c23c619ba35cde97582749017b30d05b",
"assets/packages/country_code_picker/flags/ni.png": "7aa766978de0bfced5c614d3a4dd46e2",
"assets/packages/country_code_picker/flags/mg.png": "d28582cd8732efb35c02d01f9cf9e406",
"assets/packages/country_code_picker/flags/ht.png": "fe14fe09c81536cfe70133ac590d836a",
"assets/packages/country_code_picker/flags/ss.png": "9eb46e67734c1622539b4381dff28d9a",
"assets/packages/country_code_picker/flags/gm.png": "ace7f4c74997cd35beaf9849c284bc6f",
"assets/packages/country_code_picker/flags/bf.png": "3618e73cd4b7f191937724714eba37ac",
"assets/packages/country_code_picker/flags/cx.png": "29dcb4247b25541191e6b75847ae7f45",
"assets/packages/country_code_picker/flags/tv.png": "30e1615e67ab1b3027ca362971049a8d",
"assets/packages/country_code_picker/flags/dz.png": "7d94b9067d13e1ed34a076913455e29c",
"assets/packages/country_code_picker/flags/tt.png": "c81d6e8884fa1a26aa1c825d68e7398d",
"assets/packages/country_code_picker/flags/gn.png": "949c7b1b0790f84ff82ea766bcab3d85",
"assets/packages/country_code_picker/flags/hk.png": "d06a8b5870d8eac08cff0ff8714fe111",
"assets/packages/country_code_picker/flags/ao.png": "5d2cd49b39ae7d5a5cd1960d20c0d685",
"assets/packages/country_code_picker/flags/io.png": "cb7ec25e9b4f1f3ce0bbace3806c3481",
"assets/packages/country_code_picker/flags/km.png": "885e11d748f9b9a71683edc2a86b41ce",
"assets/packages/country_code_picker/flags/aw.png": "55e7078312caf7d71d9fd7e5e40c2994",
"assets/packages/country_code_picker/flags/gw.png": "b005e6ad0bd21a3e404748a4d33a74cf",
"assets/packages/country_code_picker/flags/ro.png": "24279f6e454abe97995de26f41df13ef",
"assets/packages/country_code_picker/flags/tj.png": "5931da105eed9ddf3816a2b104a2419e",
"assets/packages/country_code_picker/flags/rs.png": "e26bc71451cd6035808dc8c261e29bab",
"assets/packages/country_code_picker/flags/bb.png": "9fbc5d4f7c393f77fd1205fe00b03305",
"assets/packages/country_code_picker/flags/tl.png": "36ac1aa3561d2369883c21b7e22e308b",
"assets/packages/country_code_picker/flags/bh.png": "f0781ba3c2a16d0cfd82241292ad2666",
"assets/packages/country_code_picker/flags/gg.png": "f87595b1a0a87452ec6ec5ea04e2f2e7",
"assets/packages/country_code_picker/flags/ng.png": "94cd6ef1ff5afe48e08f965bdbfe5d34",
"assets/packages/country_code_picker/flags/kh.png": "5d3c721e122c7f7273ed02ab5f960895",
"assets/packages/country_code_picker/flags/li.png": "b33a40a2f2248fc922c179f3aaf1dc69",
"assets/packages/country_code_picker/flags/mn.png": "81418937faea93c838de2d29430c93f6",
"assets/packages/country_code_picker/flags/my.png": "152ea892fa4a99cd4e05227b985e44fd",
"assets/packages/country_code_picker/flags/eh.png": "36fe82d7d8554c606e24bd01626cbf71",
"assets/packages/country_code_picker/flags/by.png": "917736dbe22a1f28264695ceb7c2dfca",
"assets/packages/country_code_picker/flags/pr.png": "c1e7f1aeb02eca4f05f711f60a115126",
"assets/packages/country_code_picker/flags/ky.png": "9317109d319e91c1018ba6ae8af319b1",
"assets/packages/country_code_picker/flags/zm.png": "cdeee4e4df432a7e25e516b6e3af259b",
"assets/packages/country_code_picker/flags/bv.png": "63b9529e994d70126338bf3d0ad1dfe9",
"assets/packages/country_code_picker/flags/ir.png": "682dd7c444ce5a53402da370b73b3c70",
"assets/packages/country_code_picker/flags/dm.png": "2f41b45d9c9e0ef67c8e09c69eaebfdd",
"assets/packages/country_code_picker/flags/as.png": "5fe2e204149ba8e8a2496c2fc1d139aa",
"assets/packages/country_code_picker/flags/hn.png": "1f490f7b6b1e1e0ba8197fc7733834dc",
"assets/packages/country_code_picker/flags/gh.png": "9203d2be95747ac5dd51d7be7e673aa5",
"assets/packages/country_code_picker/flags/bd.png": "4a2e0639a05c3d834eeb6e2867b68de3",
"assets/packages/country_code_picker/flags/la.png": "3846e54dafd077f706b57cdd4c416c9c",
"assets/packages/country_code_picker/flags/mx.png": "77d253b4cb33e8a385c7fdf6c8ccdd04",
"assets/packages/country_code_picker/flags/pa.png": "adb60a5737eeb5ce603426ea1ce1f803",
"assets/packages/country_code_picker/flags/cw.png": "5d8b526d2cd2fee56a6be01970127a95",
"assets/packages/country_code_picker/flags/rw.png": "38ce0690759a48c8f2a838b145e7a2eb",
"assets/packages/country_code_picker/flags/ar.png": "183f223e756b46fe3980ae372a546748",
"assets/packages/country_code_picker/flags/mt.png": "0d6ce9471c0aee06ad2a32cc76d88ff1",
"assets/packages/country_code_picker/flags/ae.png": "b48f8af204a5c8ee187f8ff79c1dfb40",
"assets/packages/country_code_picker/flags/al.png": "312dc2fae6521bf9d7907c173f7faf3a",
"assets/packages/country_code_picker/flags/py.png": "499cf5462722405c93c18d8a6462bb56",
"assets/packages/country_code_picker/flags/aq.png": "7c811ba5e44d6e427fba1587574085e3",
"assets/packages/country_code_picker/flags/ma.png": "938bec4dab393a26ccf52886b0296f5b",
"assets/packages/country_code_picker/flags/hr.png": "04eae72eb5a5b8eacb1e5f81ad29e89d",
"assets/packages/country_code_picker/flags/il.png": "4ab78c100b50b8c9ff138de7a2a54b2b",
"assets/packages/country_code_picker/flags/kp.png": "d2f7d3a426ee9fb8095e9d0a5a2dc74c",
"assets/packages/country_code_picker/flags/bq.png": "186f87fbd5724b738c1ffd19ff528bd2",
"assets/packages/country_code_picker/flags/cf.png": "36ded8ed9a2459dded98d0a5ec29a181",
"assets/packages/country_code_picker/flags/de.png": "2a200e768df33bf7d063eae8370346ff",
"assets/packages/country_code_picker/flags/bo.png": "a6e8eccba5634c4adefefc4fe12aa41b",
"assets/packages/country_code_picker/flags/mw.png": "46d3d57db04638ab7528afe4f1c35029",
"assets/packages/country_code_picker/flags/pk.png": "dd1e7c81a6a41bb5302a60c90549c528",
"assets/packages/country_code_picker/flags/sd.png": "286aba163148a52f707a68889afb71c6",
"assets/packages/country_code_picker/flags/vc.png": "14a1f07c86a9a18fb193c6e76e7d85c7",
"assets/packages/country_code_picker/flags/bn.png": "006c2789eaa0120da9a0ac0c29103096",
"assets/packages/country_code_picker/flags/pw.png": "5b403a2758dc70bba50efffa64decdbc",
"assets/packages/country_code_picker/flags/fr.png": "1e6d141e8d34136bd11040ebb997c195",
"assets/packages/country_code_picker/flags/ai.png": "7c12efda67c2c854fb95a903fbf6a6fa",
"assets/packages/country_code_picker/flags/um.png": "701aeee5bf445569645edaa245b62bbe",
"assets/packages/country_code_picker/flags/uz.png": "bb50242a8b2d3fa4699572a3e14bd6c9",
"assets/packages/country_code_picker/flags/mp.png": "b66a2ed9856fcd51b99369cddce08387",
"assets/packages/country_code_picker/flags/sv.png": "a7c4e8c87bcdfc6449290246f2340f13",
"assets/packages/country_code_picker/flags/za.png": "07748cb07c88a58c471b5bc35a0484b0",
"assets/packages/country_code_picker/flags/ch.png": "7b9a7bba5a3f2be6d688e457c4d45a2b",
"assets/packages/country_code_picker/flags/sz.png": "f58f7f50b02f70c5552e4e7a628b953e",
"assets/packages/country_code_picker/flags/mu.png": "5851f282762bed47111e13c70275912e",
"assets/packages/country_code_picker/flags/vi.png": "919b8c1a14444c9511e8b6557829e40f",
"assets/packages/country_code_picker/flags/et.png": "ceb7b26273d41b707db2f9ea01e7f6b5",
"assets/packages/country_code_picker/flags/ls.png": "f991668f9d9cfbed5b5484202afedf8d",
"assets/packages/country_code_picker/flags/tm.png": "c0c2dd4d45d61ef5b67d8d022c5f77ee",
"assets/packages/country_code_picker/flags/cn.png": "d04bc4123b72c358c019e0ce0e0f3058",
"assets/packages/country_code_picker/flags/na.png": "73da8ae95e5e86340c9bf4a8d0dea94b",
"assets/packages/country_code_picker/flags/id.png": "3e5a8392d84fcf96685b69bc8dae452e",
"assets/packages/country_code_picker/flags/lc.png": "99b3945f8eeee21108faf1fc1020b016",
"assets/packages/country_code_picker/flags/om.png": "1afd650781123f389729f5b8c6cb0499",
"assets/packages/country_code_picker/flags/bg.png": "6c9c928530433627342cce616825dc16",
"assets/packages/country_code_picker/flags/ba.png": "bc3acfb9871894c72ad42b38bb501f37",
"assets/packages/country_code_picker/flags/vg.png": "9eefe80bae6f57c8c30c6a883737bfd3",
"assets/packages/country_code_picker/flags/ad.png": "ebaabca28d2749f0a846ed5958444b6e",
"assets/packages/country_code_picker/flags/it.png": "6efb285788d323664fbbc371f773f1fa",
"assets/packages/country_code_picker/flags/fj.png": "52ab8b4034cb498cf3d79e9c6208d357",
"assets/packages/country_code_picker/flags/bl.png": "ec91afdfc4e78aa71fb83ac6d6c6f103",
"assets/packages/country_code_picker/flags/kw.png": "c8d4ce882a8dc307256525b093e16e51",
"assets/packages/country_code_picker/flags/gp.png": "031e5b6098f5ed49f23a2c9064f78ffe",
"assets/packages/country_code_picker/flags/ye.png": "7bbf24f4919e65c7b2bce11a6ac0e6d8",
"assets/packages/country_code_picker/flags/si.png": "2bc04ad0f1667f4acabbe6205da74b5f",
"assets/packages/country_code_picker/flags/nl.png": "186f87fbd5724b738c1ffd19ff528bd2",
"assets/packages/country_code_picker/flags/gi.png": "23a1160647709a4970a97ebc951b8dc5",
"assets/packages/country_code_picker/flags/nf.png": "add27a98d6b3064e5b1a7e97b35c4bbe",
"assets/packages/country_code_picker/flags/in.png": "c7fcdd74d1b64eaeb96c15c8c847b0f5",
"assets/packages/country_code_picker/flags/tc.png": "80533dc06716a47a3379fe9b4483d21c",
"assets/packages/country_code_picker/flags/tn.png": "818cb0e0647df03dba6f04c8d982870c",
"assets/packages/country_code_picker/flags/gb-wls.png": "16b6feb6440e325c87e0cbc0ab8f7646",
"assets/packages/country_code_picker/flags/nz.png": "3b716d5c1bdc405b341672ced086d517",
"assets/packages/country_code_picker/flags/va.png": "8450e1d86318a01eaadf98dfe0bfb1a1",
"assets/packages/country_code_picker/flags/nr.png": "d597707e2bf1d77f5f2994fc913ff1ed",
"assets/packages/country_code_picker/flags/pn.png": "9dc5b0788b5c50a28676aae13c794351",
"assets/packages/country_code_picker/flags/az.png": "414520799960953a74623e10958e480f",
"assets/packages/country_code_picker/flags/jp.png": "a683bbc613d80a871908ea77d35ab042",
"assets/packages/country_code_picker/flags/kr.png": "bfb02b50bcae24fb917444109077bc84",
"assets/packages/country_code_picker/flags/je.png": "ecf51e5cb395089ca9433dcad6406390",
"assets/packages/country_code_picker/flags/at.png": "6999a97201c96153ec2f74104ef1fc84",
"assets/packages/country_code_picker/flags/zw.png": "b0662d3a5b859b252bb2c09dd1d8db79",
"assets/packages/country_code_picker/flags/vn.png": "acf8de20f09079c1440b33f885b0eb90",
"assets/packages/country_code_picker/flags/uy.png": "ee5d517f6c3c87c892743ca301e63234",
"assets/packages/country_code_picker/flags/er.png": "4aca927fe10eeb20e02b4e2ccaddf3d1",
"assets/packages/country_code_picker/flags/nu.png": "4dce9dd4e027fe84b6a831a77042c666",
"assets/packages/country_code_picker/flags/co.png": "0f5d47d7ebc1527064db0903c4f6365c",
"assets/packages/country_code_picker/flags/sj.png": "63b9529e994d70126338bf3d0ad1dfe9",
"assets/packages/country_code_picker/flags/sm.png": "f3a137e811e7f24958dce35ebacbd666",
"assets/packages/country_code_picker/flags/pf.png": "a5b1f7ac8552b6ae0b325584358571eb",
"assets/packages/country_code_picker/flags/kz.png": "e097a9a70605c7380a58c5c104ef6cc1",
"assets/packages/country_code_picker/flags/sh.png": "68943ce45ea0d934000830e1bdf0eef4",
"assets/packages/country_code_picker/flags/gq.png": "b240587b310691df4cb5933c7d114f02",
"assets/packages/country_code_picker/flags/mm.png": "e7930d9901eafd6a3673e36a81ee7a15",
"assets/packages/country_code_picker/flags/sy.png": "67aaf4d2fa272d2b47a2171e84cc6092",
"assets/packages/country_code_picker/flags/bj.png": "b6f8f2289302bf3d7c3f5f6c31da7f9f",
"assets/packages/country_code_picker/flags/dj.png": "ba146968a093b7382e46551b96ea505f",
"assets/packages/country_code_picker/flags/lv.png": "65702796b93f73f58714d98d89d8e5c6",
"assets/packages/country_code_picker/flags/bm.png": "f1157936f96eca5491f1d7574e1fab5f",
"assets/packages/country_code_picker/flags/sg.png": "ca0f9dc803c60a68202f9741c05dbc36",
"assets/packages/country_code_picker/flags/ua.png": "a9ce20024f04d0f8e1cc18f28f6a5219",
"assets/packages/country_code_picker/flags/cc.png": "8bdac0b2f4815b1862ab2c4a1b146118",
"assets/packages/country_code_picker/flags/iq.png": "e6ffec3b1c5fcb05a28b35c39cb76fac",
"assets/packages/country_code_picker/flags/yt.png": "031e5b6098f5ed49f23a2c9064f78ffe",
"assets/packages/country_code_picker/flags/fo.png": "613990d19f4175d628e15c54e1106b12",
"assets/packages/country_code_picker/flags/ru.png": "05d6836ad3ae411a62fa8c264a2828bd",
"assets/packages/country_code_picker/flags/ag.png": "33a71105c24acbc07c42f0bafbb05ca5",
"assets/packages/country_code_picker/flags/tg.png": "eddde19360efd58e00f748cbe24998d3",
"assets/packages/country_code_picker/flags/wf.png": "54ca3d44fc665fa4e7751446ef1b8b89",
"assets/packages/country_code_picker/flags/cd.png": "8208f03abf82ac9502b248b676a263b5",
"assets/packages/country_code_picker/flags/xk.png": "9662b663b021640a12fa54edee07dc6d",
"assets/packages/country_code_picker/flags/es.png": "e9b8d5ff3d181b1dcb73c8f6c365c22d",
"assets/packages/country_code_picker/flags/tw.png": "443b567cf29fb044e38fd979f8b1e410",
"assets/packages/country_code_picker/flags/bz.png": "272df59f3c37a655747f88b42f7894a0",
"assets/packages/country_code_picker/flags/bi.png": "239d6de0c0585747f9ac7831e8deec74",
"assets/packages/country_code_picker/flags/gf.png": "1b48f47c6a3b6311711214667191693f",
"assets/packages/country_code_picker/flags/cm.png": "db9c5215648c69818b7b26b4fc7afa39",
"assets/packages/country_code_picker/flags/sn.png": "9269f8ddab765061d9ad9d391b51483f",
"assets/packages/country_code_picker/flags/is.png": "3b294ab6373ab2d06f93a2c498289447",
"assets/packages/country_code_picker/flags/cv.png": "0c36880587b8372626a1db7d19e275fd",
"assets/packages/country_code_picker/flags/ph.png": "523381edeb53018be7c83a19a9cecbf1",
"assets/packages/country_code_picker/flags/ml.png": "d4ffba7e90b70311b28dd21e1338ddba",
"assets/packages/country_code_picker/flags/ne.png": "926b7cb1001bd95b3ce89418e399ac92",
"assets/packages/country_code_picker/flags/gb.png": "68943ce45ea0d934000830e1bdf0eef4",
"assets/packages/country_code_picker/flags/sa.png": "b702db2d853020bd50433b79539e4fbd",
"assets/packages/country_code_picker/flags/pg.png": "ec3ebb63f4f8542ae35b449b2890054e",
"assets/packages/country_code_picker/flags/ke.png": "66ea37a78e7566b09b14f9f22ad0d899",
"assets/packages/country_code_picker/flags/qa.png": "b1f81445e867ee8850e81b192acf48d9",
"assets/packages/country_code_picker/flags/lb.png": "3535d9d3a811accd7ff3e697b446c8cf",
"assets/packages/country_code_picker/flags/mo.png": "9d906829177fee37f96284a35bf4c28b",
"assets/packages/country_code_picker/flags/st.png": "cff2f4693af0d15fbe0e03593468ce16",
"assets/packages/country_code_picker/flags/gr.png": "d52d555c4e863ed9e80f1dacc58b9e68",
"assets/packages/country_code_picker/flags/fk.png": "64388f821195505f2e6b304527af8dc9",
"assets/packages/country_code_picker/flags/md.png": "4f5e77127acb1bb40196c588ceec50ff",
"assets/packages/country_code_picker/flags/ca.png": "61406764ed580dbbcc5c7be423041dac",
"assets/packages/country_code_picker/flags/gl.png": "a47464651ca00c58fbe2a2b7c5eebf31",
"assets/packages/country_code_picker/flags/ms.png": "1ae6204f38bf7fa647ef2a8803f070b0",
"assets/packages/country_code_picker/flags/am.png": "ae346b14bd3dcc5fcf8bab2c9af869bc",
"assets/packages/country_code_picker/flags/tr.png": "eefade768ef9f85f309c70ef5b2be1da",
"assets/packages/country_code_picker/flags/jm.png": "70efa47137feca6ea5e7e404d5c5b0aa",
"assets/packages/country_code_picker/flags/sr.png": "e650215abffe711a2ad3cc95e0bed182",
"assets/packages/country_code_picker/flags/lr.png": "04a1baa5259520256b4898b93811e4d7",
"assets/packages/country_code_picker/flags/cl.png": "2025068d36d4f9d19b79c0a4878d5c3e",
"assets/packages/country_code_picker/flags/mh.png": "eb2bd6d911cdccfb83a5723f5e288ebb",
"assets/packages/country_code_picker/flags/vu.png": "dafc9bf39e8c00959d53f33f71e8d103",
"assets/packages/country_code_picker/flags/gb-nir.png": "68943ce45ea0d934000830e1bdf0eef4",
"assets/packages/country_code_picker/flags/pe.png": "b15810fc1e69b94cb6f08da951b0226c",
"assets/packages/country_code_picker/flags/sx.png": "1c6c446f48f0d2398a4b87c9813c7c34",
"assets/packages/country_code_picker/flags/ec.png": "4049e3e742bc5154bded8ac6143e1238",
"assets/packages/country_code_picker/flags/cr.png": "b177551a33e617c81e7f002bf0e4fc39",
"assets/packages/country_code_picker/flags/gy.png": "740438fa8c7bd4960130bbc9da20d6e1",
"assets/packages/country_code_picker/flags/re.png": "031e5b6098f5ed49f23a2c9064f78ffe",
"assets/packages/country_code_picker/flags/ge.png": "caaf5e4a7b0ea368e4e46654085cf9cf",
"assets/packages/country_code_picker/flags/kg.png": "6a4d79787b2de772efeca485ab50f3d0",
"assets/packages/country_code_picker/flags/eu.png": "2854bd352dece57cdf73260b82bf00f9",
"assets/packages/country_code_picker/flags/me.png": "a0501dc59b9ee771f52475635d4b12b5",
"assets/packages/country_code_picker/flags/ki.png": "b5d6a83f16f37ce33e4957efd3be882c",
"assets/packages/country_code_picker/flags/pt.png": "5218fefbf9e27aa9db958468bf588821",
"assets/packages/country_code_picker/flags/ps.png": "daab0fe6fe8c0e6a4550e65dfbd038f1",
"assets/packages/country_code_picker/flags/ci.png": "22d9784243fc0b2cb39715c706a44e4c",
"assets/packages/country_code_picker/flags/lu.png": "d6a50d231500da3db90790f5a0fe1131",
"assets/packages/country_code_picker/flags/do.png": "03b5ac0bda83c70a031bb19b449cef71",
"assets/packages/country_code_picker/flags/gb-eng.png": "84e821e05239f3df1d8eadd96375991f",
"assets/packages/country_code_picker/flags/gb-sct.png": "5df0655b568b27195295d266773a82b8",
"assets/packages/country_code_picker/flags/hm.png": "74475c0254a3171ba9a72658853bc000",
"assets/packages/country_code_picker/flags/mc.png": "a603aa78a1fb36e71ccc3d87b022d772",
"assets/packages/country_code_picker/flags/cz.png": "a0f2517a85a30db53fa2755be652556d",
"assets/packages/country_code_picker/flags/pl.png": "17e36c5d3a243d054dd9cecf3b9c23ac",
"assets/packages/country_code_picker/flags/bw.png": "cbbebb48747a29cb9080cdacfe01d96d",
"assets/packages/country_code_picker/flags/hu.png": "52cf8bd98341b85079ed972e08223fd1",
"assets/packages/country_code_picker/flags/gs.png": "73d18ad4121d509f79cd510b982d595a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/assets/img/psp.png": "0c1cc248118b972df0baaa4419936ee2",
"assets/assets/svg/psp.svg": "300a1f7b731071b75c74aa2a8a12c985",
"assets/AssetManifest.json": "aec0df924a2ffa2adecbe2de31d6c2d8",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"index.html": "9eb2e859d46c9938db47b2b145643a33",
"/": "9eb2e859d46c9938db47b2b145643a33"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/LICENSE",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      // Provide a no-cache param to ensure the latest version is downloaded.
      return cache.addAll(CORE.map((value) => new Request(value, {'cache': 'no-cache'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');

      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }

      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#')) {
    key = '/';
  }
  // If the URL is not the the RESOURCE list, skip the cache.
  if (!RESOURCES[key]) {
    return event.respondWith(fetch(event.request));
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache. Ensure the resources are not cached
        // by the browser for longer than the service worker expects.
        var modifiedRequest = new Request(event.request, {'cache': 'no-cache'});
        return response || fetch(modifiedRequest).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.message == 'skipWaiting') {
    return self.skipWaiting();
  }

  if (event.message = 'downloadOffline') {
    downloadOffline();
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey in Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.add(resourceKey);
    }
  }
  return Cache.addAll(resources);
}
