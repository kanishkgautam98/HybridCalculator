value [0-9]+\.?|[0-9]*\.[0-9]+
%%
[ \t]   { ; }
log10     return sys_log;
fact      return sys_fact;
bin_to_dec   return sys_bin_to_dec;
pi      return sys_pi;
sin     return sys_sin;
cos     return sys_cos;
tan     return sys_tan;
and     return sys_and;
sinh    return sys_sinh;
cosh    return sys_cosh;
tanh    return sys_tanh;
asin    return sys_asin;
acos    return sys_acos;
atan    return sys_atan;
xor     return sys_xor;
or      return sys_or;
ceil    return sys_ceil;
floor   return sys_floor;
abs     return sys_abs;
{value}	{ yylval=atof(yytext);return sys_value; }
"<<"    return sys_leftshift;
">>"    return sys_rightshift;
"++"    return sys_inc;
"--"    return sys_dec;
"+"     return sys_plus;
"-"     return sys_minus;
"~"     return sys_unaryminus;
"/"     return sys_div;
"*"     return sys_mul;
"^"     return sys_pow;
sqrt    return sys_sqrt;
"("     return sys_openbracket;
")"     return sys_closebracket;
"%"     return sys_mod;
"^^"    return sys_xor;
"="     return sys_assign;
"&&"    return sys_land;
"||"    return sys_or;
"|"     return sys_ior;
"&"     return sys_land;
\n|. {return yytext[0];}
