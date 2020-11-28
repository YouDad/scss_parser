%{
%}

%x VALUE__color

color_value ({color_rgb}|{color_hsl}|{color_hex}|{color_named}|{color_cur})

color_rgb ("rgb""a"?"("[^\)]")")
color_hsl ("hsl""a"?"("[^\)]")")
color_hex (#{hex_digit}+)
color_named ({colors_0}|{colors_1}|{colors_2}|{colors_3})
color_cur ("currentcolor")

colors_0 ({color_0}|{color_1}|{color_2}|{color_3}|{color_4}|{color_5})
colors_1 ({color_6}|{color_7}|{color_8}|{color_9}|{color_10}|{color_11})
colors_2 ({color_12}|{color_13}|{color_14}|{color_15}|{color_16}|{color_17})
colors_3 ({color_18}|{color_19}|{color_20}|{color_21}|{color_22}|{color_23})
color_0  (black|silver|gray|white|maroon|red|purple|fuchsia|green|lime)
color_1  (olive|yellow|navy|blue|teal|aqua|orange|aliceblue|antiquewhite)
color_2  (aquamarine|azure|beige|bisque|blanchedalmond|blueviolet|brown)
color_3  (burlywood|cadetblue|chartreuse|chocolate|coral|cornflowerblue)
color_4  (cornsilk|crimson|cyan|aqua|darkblue|darkcyan|darkgoldenrod)
color_5  (darkgray|darkgreen|darkgrey|darkkhaki|darkmagenta|darkolivegreen)
color_6  (darkorange|darkorchid|darkred|darksalmon|darkseagreen|darkslateblue)
color_7  (darkslategray|darkslategrey|darkturquoise|darkviolet|deeppink)
color_8  (deepskyblue|dimgray|dimgrey|dodgerblue|firebrick|floralwhite)
color_9  (forestgreen|gainsboro|ghostwhite|gold|goldenrod|greenyellow|grey)
color_10 (honeydew|hotpink|indianred|indigo|ivory|khaki|lavender)
color_11 (lavenderblush|lawngreen|lemonchiffon|lightblue|lightcoral|lightcyan)
color_12 (lightgoldenrodyellow|lightgray|lightgreen|lightgrey|lightpink)
color_13 (lightsalmon|lightseagreen|lightskyblue|lightslategray)
color_14 (lightslategrey|lightsteelblue|lightyellow|limegreen|linen|magenta)
color_15 (fuchsia|mediumaquamarine|mediumblue|mediumorchid|mediumpurple)
color_16 (mediumseagreen|mediumslateblue|mediumspringgreen|mediumturquoise)
color_17 (mediumvioletred|midnightblue|mintcream|mistyrose|moccasin)
color_18 (navajowhite|oldlace|olivedrab|orangered|orchid|palegoldenrod)
color_19 (palegreen|paleturquoise|palevioletred|papayawhip|peachpuff|peru)
color_20 (pink|plum|powderblue|rosybrown|royalblue|saddlebrown|salmon)
color_21 (sandybrown|seagreen|seashell|sienna|skyblue|slateblue|slategray)
color_22 (slategrey|snow|springgreen|steelblue|tan|thistle|tomato|turquoise)
color_23 (violet|wheat|whitesmoke|yellowgreen|rebeccapurple)

%%

("background-color"|"color"): {
	ENTER_STATE(VALUE__color);
	log::debug("attr: '%s'", yytext);
	yylval.str = yytext;
	return ATTR;
}

<VALUE__color>({color_value}|{global_value}) {
	EXIT_STATE();
	log::debug("<VALUE__color>value '%s'", yytext);
	yylval.str = yytext;
	return VALUE;
}

<VALUE__color>\n {}

<VALUE__color>. {
	log::debug("<VALUE__color>any: '%s'", yytext);
}

%%
