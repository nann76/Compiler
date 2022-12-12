%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<ctype.h>

    #ifndef YYSTYPE 
    #define YYSTYPE char*
    #endif

    char idStr[50];
    char numStr[50];


    int yylex();
    extern int yyparse();
    FILE* yyin;
    void yyerror(const char* s);

%}

%token NUMBER ADD SUB MUL DIV LBR RBR ID


%left ADD SUB
%left MUL DIV
%right UMINUS



%%

lines   :   lines expr ';' {printf("%s\n",$2);}
|       lines ';'
|
;


expr    :   expr ADD expr {$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"+ ");}
|       expr SUB expr {$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"- ");}
|       expr MUL expr {$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"* ");}
|       expr DIV expr {$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"/ ");}
|       LBR expr RBR  {$$=(char *)malloc(50*sizeof(char));strcpy($$,$2);}
|       NUMBER {$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$," ");}
|       ID {$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$," ");}
;




%%

int yylex(){

    int t;

    while(1){

        t=getchar();
        if(t=='\n'||t==' '|| t=='\t'){}

        else if(isdigit(t)){

            int ti=0;
            while(isdigit(t)){

                numStr[ti]=t;
                t=getchar();
                ti++;

            }
            numStr[ti]='\0';
            yylval=numStr;
            ungetc(t,stdin);
            return NUMBER;

        }

        else if((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')){

            int ti=0;
            while((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')||(t>='0'&&t<='9')){

                idStr[ti]=t;
                t=getchar();
                ti++;

            }
            idStr[ti]='\0';
            yylval=idStr;
            ungetc(t,stdin);
            return ID;


        }
        
        else if(t=='+') return ADD;
        else if(t=='-') return SUB;
        else if(t=='*') return MUL;
        else if(t=='/') return DIV;
        else if(t=='(') return LBR;
        else if(t==')') return RBR; 

        else return t;


    }
}

int main(void){

    yyin=stdin;
    do{

        yyparse();

    }while(!feof(yyin));
    return 0;


}


void yyerror(const char* s){

    fprintf(stderr,"PArse error: %s\n",s);
    exit(1);

}
    

