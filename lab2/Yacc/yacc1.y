%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<ctype.h>

    #ifndef YYSTYPE 
    #define YYSTYPE double
    #endif

    int yylex();
    extern int yyparse();
    FILE* yyin;
    void yyerror(const char* s);

%}

%token NUMBER ADD SUB MUL DIV LBR RBR

%left ADD SUB
%left MUL DIV
%right UMINUS


%%

lines   :   lines expr ';' {printf("%f\n",$2);}
|       lines ';'
|
;


expr    :   expr ADD expr {$$=$1 + $3;}
|       expr SUB expr {$$=$1 - $3;}
|       expr MUL expr {$$=$1 * $3;}
|       expr DIV expr {$$=$1 / $3;}
|       LBR expr RBR  {$$=$2;}
|       SUB expr %prec UMINUS {$$=-$2;}
|       NUMBER {$$=$1;}
;




%%

int yylex(){

    int t;

    while(1){

        t=getchar();
        if(t=='\n'||t==' '|| t=='\t'){}

        else if(isdigit(t)){

            yylval=0;
            while(isdigit(t)){

                yylval=yylval*10+t-'0';
                t=getchar();

            }
            ungetc(t,stdin);
            return NUMBER;

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
    

