%{

#include <stddef.h>
#include <ctype.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include<stdio.h>
#include <alloca.h>
#define YYSTYPE double

long int bin_to_dec(long int val){
    long int left,s=0,pw=0;
    while(val>0){
         left = val%10;
         val/=10;
         s = s + left * pow(2,pw);
         pw++;
    }
    return s;
}

float fact(int v){
    float r = 1;
    int i;
    for (i = 1; i <= v; i++)
        r = r * i;
    return r;
}

%}

%token value sys_mod sys_rightshift sys_leftshift sys_pi
%token sys_plus sys_minus sys_div sys_mul sys_pow sys_sqrt sys_openbracket sys_closebracket sys_unaryminus
%token sys_asin sys_acos sys_atan sys_sin sys_sinh sys_cos sys_cosh sys_tan sys_tanh sys_inc sys_dec sys_land sys_or  sys_xor sys_assign sys_ior sys_and  sys_ceil sys_floor sys_abs sys_fact sys_bin_to_dec
%left sys_plus sys_minus sys_mul sys_div sys_unaryminus sys_land sys_or sys_xor sys_and sys_ior sys_log
%%
L	:	L E '\n'	{ printf("%g\n", $2); }
	|	L '\n'
	|
	;
E:   LOR
        ;
LOR: LAND
        | LOR sys_or LAND
          { $$ = (int) $1 || (int) $3; }
        ;
LAND: or
        | LAND sys_land or
          { $$ = (int) $1 && (int) $3; }
        ;
or: or1
        | or sys_ior or1
          { $$ = (int) $1 | (int) $3; }
        ;
or1: and
        | or1 sys_xor and
          { $$ = (int) $1 ^ (int) $3; }
        ;
and: shift
        | and sys_and shift
          { $$ = (int) $1 & (int) $3; }
        ;
shift: pow
        | shift sys_leftshift pow
          { $$ = (int) $1 << (int) $3; }
        | shift sys_rightshift pow
          { $$ = (int) $1 >>(int) $3; }
        ;
pow: add
        | pow sys_pow add { $$ = pow($1,$3); }
	| sys_sqrt sys_openbracket E sys_closebracket { $$ = sqrt($3) ; }
        ;
add: mul
        | add sys_plus mul  { $$ = $1 + $3;}
        | add sys_minus mul { $$ = $1 - $3; }
        ;
mul: unary
        | mul sys_mul unary { $$ = $1 * $3; }
        | mul sys_div unary { $$ = $1 / $3; }
        | mul sys_mod unary { $$ = fmod($1,$3); }
        ;
unary: post
        | sys_minus primary %prec sys_unaryminus { $$ = -$2; }
        | sys_inc unary { $$ = $2+1; }
        | sys_dec unary { $$ = $2-1; }
        | sys_log unary { $$ = log($2); }
        ;
post   : primary
        | post sys_inc { $$ = $1+1; }
        | post sys_dec { $$ = $1-1; }
        ;
 primary:
         sys_pi { $$ = M_PI; }
        | sys_openbracket E sys_closebracket { $$ = $2; }
        | function
        ;
function: sys_sin sys_openbracket E sys_closebracket
               { $$ = (cos($3)*tan($3)); }
        | sys_cos sys_openbracket E sys_closebracket
               { $$ = cos($3); }
        | sys_sinh sys_openbracket E sys_closebracket
               { $$ = sinh($3); }
        | sys_asin sys_openbracket E sys_closebracket
               { $$ = asin($3); }
        | sys_acos sys_openbracket E sys_closebracket
               { $$ = acos($3); }
        | sys_atan sys_openbracket E sys_closebracket
               { $$ = atan($3);}
        | sys_tan sys_openbracket E sys_closebracket
               { $$ = tan($3);}
        | sys_cosh sys_openbracket E sys_closebracket
               { $$ = cosh($3);}
        | sys_tanh sys_openbracket E sys_closebracket
               { $$ = tanh($3);}
	| sys_ceil sys_openbracket E sys_closebracket
		{ $$ = ceil($3);}
	| sys_floor sys_openbracket E sys_closebracket
		{ $$ = floor($3);}
	| sys_abs sys_openbracket E sys_closebracket
		{ $$ = abs($3);}
	| sys_fact sys_openbracket E sys_closebracket
		{ $$ = fact((int)$3);}
	| sys_bin_to_dec sys_openbracket E sys_closebracket
		{ $$ = bin_to_dec((float)$3);}
	| value
        ;
%%

#include <stdio.h>
#include <ctype.h>
#include "lex.yy.c"
#include <string.h>
char *progname;
yyerror( s )
char *s;
{
  warning( s , ( char * )0 );
  yyparse();
}

warning( s , t )
char *s , *t;
{
  fprintf( stderr ,"%s: %s\n" , progname , s );
  if ( t )
    fprintf( stderr , " %s\n" , t );
}
