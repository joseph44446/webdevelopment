//crc check
#include<stdio.h>
#include<string.h>
// mode=1 is for calculating CRC of original message and create final message
//to be transmitted at sender's end
// mode=0 is for calculating CRC of received message at reciever's end
int crc(char *input, char *output, const char *gp, int mode)
{
	int j,k;
	strcpy(output,input); // copy original message to output
	if(mode)
	{
		for(j=1; j<strlen(gp); j++)
		// append as many zeroes as the width of generator polynomial.
			strcat(output,"0");
	}
	// calculate final message to be transmitted and store it in
	// output - loop simulates CRC division and finding of remainder
	for(j=0; j<strlen(input); j++)
		if(*(output+j) == '1')
			for(k=0; k<strlen(gp); k++)
			{
				// equivalent to performing XOR operation
				if (((*(output+j+k) == '0')&&(gp[k]=='0')||
					(*(output+j+k)=='1') && (gp[k] == '1')))
				*(output+j+k)='0';
				else
				*(output+j+k)='1';
			}

	// if any of the bits is 1, then output is not 0, hence there is error
	for(j=0; j<strlen(output); j++)
		if(output[j] == '1')
			return 1;
	return 0; // error free
}
int main()
{
	char input[50],output[50],recv[50];
	const char gp[18]="1011"; // 16-bit CRC-CCITT
	//specification G(x): x^16+x^12+x^5+1
	printf("\n Enter the input message in binary\n");
	scanf("%s",input);
	crc(input,output,gp,1);
	printf("\n The transmitted message is %s%s\n", input,output+strlen(input));
	printf("\n\n Enter the recevied message in binary \n");
	scanf("%s",recv);
	if(!crc(recv,output,gp,0))
		printf("\n No error in data\n");
	else
		printf("\n Error in data transmission has occurred\n");
	return 0;
}
