%{
#include <cstdio>
#include <cstdlib>
#include <string>
#include <cstring>
#include <iostream>
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern "C" void yyerror(const char* s);
extern "C" char* yytext;

using namespace std;

class  matrix { 
   int **p, m, n; 
public: 
 int getrow(){return m;}
  int getcolumn() {return n;}
   matrix(int row, int col) 
   { 
      m = row; 
      n = col; 
      p = new int*[m]; 
      for (int i = 0; i < m; i++) 
	 p[i] = new int[n]; 
   }
   ~matrix() 
   { 
      for (int i = 0; i < m; i++) 
	 delete p[i]; 
      delete p; 
   } 
   void getChar(char* str) 
   { 
     char temp[10];
     char temp2[100];
     strcpy(temp2, str);
     int i=0, t=0;
	 
for(int k=0; k< m ; k++)
		{
		                   
		for( int j=0; j<n ; j++)
			{

				
				while (temp2[i]!=']'&& temp2[i]!=','&& temp2[i]!=';')
                                   {
					 
					
                                    if ((temp2[i]=='-'||temp2[i]=='+'|| 0<= (int)temp2[i]-(int)'0'<=9)&& temp2[i]!='[')
                                        {
					    temp[t]= temp2[i];
                                              
							t++;
					}
					
                          
                                i++;
                               }
                                 if(t>0){
                                 temp[t]='\0';
				 p[k][j]= atoi(temp);
                                        t=0;}
                                   
					if(temp2[i]!=']') i++;
   					 
 			 }

  }      


   } 
   void display() 
   { 
      cout <<"The Result Matrix is:";
      for(int i = 0; i < m; i++) 
      { 
	 cout <<endl;
		cout<<"\t"; 
	 for(int j = 0; j < n; j++) 
	 { 
	    cout << p[i][j] <<" "; 
	 } 
      } 
  cout<<endl;
   }

void add_mat(matrix* M, matrix* N){
int t1=M->m, t2=M->n, s1=N->m, s2=N->n;
if(t1==s1 && t2==s2){
 for (int i=0; i<t1; i++){
    for(int j=0; j<t2; j++){
     p[i][j]=M->p[i][j]+N->p[i][j];
		}
	}
    }
else 
{ printf("For + operator we need to have consistent dimensions"); exit(0);}

}
void sub_mat(matrix* M, matrix* N){
int t1=M->m, t2=M->n, s1=N->m, s2=N->n;
if(t1==s1 && t2==s2){
 for (int i=0; i<t1; i++){
    for(int j=0; j<t2; j++){
     p[i][j]=(M->p[i][j])-(N->p[i][j]);
		}
	}
    }
else 
{ printf("For - operator we need to have consistent dimensions"); exit(0);}

}
void mult_mat(matrix* M, matrix* N){
int t1=M->m, t2=M->n, s1=N->m, s2=N->n;
int temp = 0;
if(t2==s1){
 	for (int i=0; i<t1; i++){
 		for(int j=0; j<s2; j++){
 			for (int k = 0; k < t2; k++)
 				temp += (M->p[i][k]) * (N->p[k][j]);
 			p[i][j] = temp;
 			temp = 0;     
		}
	}
}
else 
{ printf("For * operator we need to have consistent dimensions"); exit(0);}

}
void copy_mat(matrix* M){
int t1=M->m, t2=M->n;
for (int i=0; i<t1; i++)
	for(int j=0; j<t2; j++)
   		p[i][j]=M->p[i][j];
		
}
  
};
int row(const char* m1);
int column(const char* m1);
int t1,t2,t3,t4;
%}
%locations
%union {
	int ival;
	float fval;
	char* strval;
        matrix* mat;}

%token<ival> T_INT
%token<fval> T_FLOAT
%token<strval> T_STRVAL
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_OPEN T_CLOSE T_POW
%token T_NEWLINE T_QUIT
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE
%right T_POW
%left T_CLOSE
%right T_OPEN

%type<ival> expression
%type<fval> mixed_expression
%type<mat> mat_exp
/*%type<strval> matrix_expression2*/
%start calculation

%%

calculation:
	   | calculation line
;

line: T_NEWLINE
    | mixed_expression T_NEWLINE { printf("\t The Result is: %f\n", $1);}
    | expression T_NEWLINE { printf("\t The Result is: %i\n", $1); }
    |mat_exp T_NEWLINE { $1->display();}
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
    | error T_NEWLINE   {yyerrok;}
;
mat_exp: T_STRVAL               { if(column($1)>0){$$=new matrix(row($1), column($1)); $$->getChar($1); free($1);}else {yyerror("***Does not have a proper dimension***"); exit(0);}}
          | mat_exp T_PLUS mat_exp	{	t1=$1->getrow(); t2=$3->getrow(); t3=$1->getcolumn();t4=$3->getcolumn();
						if(t1==t2 && t3==t4){$$=new matrix($1->getrow(), $1->getcolumn());$$->add_mat($1,$3); $3->~matrix(); 							$1->~matrix();}else{yyerror("***Dimensions are not consistant for addition.***");
						printf("***Error:Dimensions are not consistant for addition. The result contains the first matrix.***\n")  ;}}
	  | mat_exp T_MINUS mat_exp	{	t1=$1->getrow(); t2=$3->getrow(); t3=$1->getcolumn();t4=$3->getcolumn();
						if(t1==t2 && t3==t4){$$=new matrix($1->getrow(), $1->getcolumn());$$->sub_mat($1,$3); $3->~matrix(); 							$1->~matrix();}else{yyerror("***Dimensions are not consistant for subtraction.***");
						printf("***Error:Dimensions are not consistant for subtraction. The result contains the first matrix.***\n")  ;} }
	  | mat_exp T_MULTIPLY mat_exp	{  	t1=$1->getrow(); t2=$3->getrow(); t3=$1->getcolumn();t4=$3->getcolumn();
					 	if(t3==t2){$$=new matrix(t1, t4);$$->mult_mat($1,$3); $3->~matrix(); 						 							$1->~matrix();}else{yyerror("***Dimensions are not consistant for multiplication***");
					 	printf("***Error:Dimensions are not consistant for multiplication. The result : the first matrix.***\n")  ;} }
	  | T_OPEN mat_exp T_CLOSE	{ $$=$2; }
	  | mat_exp T_POW T_INT		{ 	t1=$1->getrow(); t3=$1->getcolumn(); t2 = $3;
	  					if($3 >1 && t1 == t3){ $$ = new matrix(t1, t3); matrix *t; t = new matrix(t1, t3); t->copy_mat($1);
	  					$$->mult_mat($1,t);
	  					while( t2 != 2 ){ t->copy_mat($$); $$->mult_mat(t, $1); t2--;}
	  					$1->~matrix(); t->~matrix();}if(t1 != t3){yyerror("***Not a square matrix.***");
	  					printf("***Error:Not a square matrix. The result contains the first matrix.***\n") ;}
	  					if($3 < 1){yyerror("***Power must be a positive integer.***");
	  					printf("***Error:Power must be a positive integer. The result contains the first matrix.***\n"); } }


;
mixed_expression: T_FLOAT                 		 { $$ = $1; }
	  | mixed_expression T_PLUS mixed_expression	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS mixed_expression	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY mixed_expression { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | T_OPEN mixed_expression T_CLOSE		 { $$ = $2; }
	  | expression T_PLUS mixed_expression	 	 { $$ = $1 + $3; }
	  | expression T_MINUS mixed_expression	 	 { $$ = $1 - $3; }
	  | expression T_MULTIPLY mixed_expression 	 { $$ = $1 * $3; }
	  | expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | mixed_expression T_PLUS expression	 	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS expression	 	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY expression 	 { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE expression	 { $$ = $1 / $3; }
	  | expression T_DIVIDE expression		 { $$ = $1 / (float)$3; }
;

expression: T_INT				{ $$ = $1; }
	  | expression T_PLUS expression	{ $$ = $1 + $3; }
	  | expression T_MINUS expression	{ $$ = $1 - $3; }
	  | expression T_MULTIPLY expression	{ $$ = $1 * $3; }
	  | T_OPEN expression T_CLOSE		{ $$ = $2; }
	  | expression T_POW expression	{ $$ = $1 ^ $3; }
;

%%
int main() {
	yyin = stdin;
	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}
void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s At line %d\n", s , yylloc.first_line);

}
int row(const char* m1){  /* count the number of rows of the string */
	int row=0;
	int i=0;
        char temp[100];
        strcpy(temp, m1);
	while( temp[i]!= ']')
		{
 			if(temp[i] == ';')
 			row++;
 			i++;

		}
return row+1;
}

int column(const char* m1){  /* count the number of coloumns of the string and show the validity of the string*/
	int col=0, col1=0,flag=0;
        int i=0;
        char temp[100];
        strcpy(temp, m1);
       while( temp[i]!=']')
		{
 			if( temp[i]==',') {col++; i++;}
                        else if((temp[i]==';')&& (flag==0)){flag=1; col1=col; col=0; i++;}
                        else if((temp[i]==';')&&(flag>0)&&(col==col1)){col1=col; col=0; i++;}
                        else if((temp[i]==';')&& (flag>0)&&(col!=col1)){break;}
                        else{i++;}
                        
                }
  if(((col1==col)&&(flag>0))||(flag==0)) return col+1;
  else return 0;
}


