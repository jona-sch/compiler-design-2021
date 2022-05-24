%{
#include "../include/vslc.h"
#include <stdio.h>
extern YYSTYPE yylval;
//enum {FUNC, PRINT, RETURN, CONTINUE, IF, THEN, ELSE, WHILE, DO, OPENBLOCK, CLOSEBLOCK,
//			VAR, NUMBER, IDENTIFIER, STRING, LSHIFT, RSHIFT }
enum { ENDOFFILE = 278, ASSIGNMENT = 279, AOP = 280, ROP = 281, BOP = 282 };
char buf[100];
char* s;

%}
%option noyywrap
%option array
%option yylineno

%state COMMENT
%state STR

%%
<INITIAL>[\t\n\r\v\ ]							{ }//return WHITESPACE; }
<INITIAL>def											{ return FUNC; }
<INITIAL>begin										{ return OPENBLOCK; }
<INITIAL>end											{ return CLOSEBLOCK; } 
<INITIAL>return										{ return RETURN; }
<INITIAL>print										{ return PRINT; } 
<INITIAL>if											  { return IF; }
<INITIAL>then										  { return THEN; }
<INITIAL>else										  { return ELSE; }
<INITIAL>while									  { return WHILE; }
<INITIAL>do											  { return DO; }
<INITIAL>continue								  { return CONTINUE; }
<INITIAL>\<\<											{ return LSHIFT; }
<INITIAL>\>\>											{ return RSHIFT; }
<INITIAL>var											{ return VAR; } 
<INITIAL>[0-9][0-9]*							{ yylval->data = (int64_t*)malloc(sizeof(int64_t)); *((int64_t*)(yylval->data)) = atoi(yytext); return NUMBER; }
<INITIAL>\"												{ s = buf; BEGIN(STR); }
<STR>\\n                       		{ *s++ = '\n'; }
<STR>\\t                     		  { *s++ = '\t'; }
<STR>\\\"                    		  { *s++ = '\"'; }
<STR>\"                     	    {
		                                *s = 0;
		                                BEGIN(INITIAL);
		                                yylval->data = strdup(buf);
		                                return STRING;
                                  }
<STR>\n      { printf("invalid string"); exit(1); }
<STR>.       { *s++ = *yytext; }
<INITIAL>[a-zA-Z\_][a-zA-Z0-9\_]*		{ yylval->data = strdup(yytext); return IDENTIFIER; }
<INITIAL>\/\/											{ BEGIN(COMMENT); }
<INITIAL>.                		    { return yytext[0]; }
<COMMENT>\n												{ BEGIN(INITIAL); }
<COMMENT>.                		    { }
%%

