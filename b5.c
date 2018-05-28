
#include<stdio.h>
int min(int x, int y)
{
	if(x<y)
	return x;
	else
	return y;
}
int main()
{
	int  cap, rate, nsec ,i, inp[25],drop=0, mini, count=0;
		
	printf("Enter bucket size :");
	scanf("%d",&cap);	
	printf("Enter transmission rate :");
	scanf("%d", &rate);	
	printf("Enter The duration of simulation in seconds : ");
	scanf("%d", &nsec);
	for(i=0;i<nsec;i++)
	{
		printf("Enter packet size at %d sec : ",i+1);
		scanf("%d", &inp[i]);
	}
	printf("\nSecond|Packet Recieved|Packet Sent|Packet Left|Packet Dropped|\n");
		
	printf("--------------------------------------------------------------\n");
	for(i=0;i<nsec;i++)
	{
		
		count+=inp[i];
		
		if(count>cap)
		{
			drop=count-cap;	
			count=cap; 	
		}
		printf("%d",i+1);	
		printf("\t%d",inp[i]);	
		mini=min(count,rate); 	
			
		printf("\t\t%d",mini);	
		count=count-mini;	
		
		printf("\t\t%d",count);
		printf("\t\t%d\n",drop);
		
		drop=0;
		sleep(1);
	}
	
	
	for(;count!=0;i++)
	{
		if(count>cap)
		{
			drop=count-cap;
			count=cap;
		}
		printf("%d",i+1);
		printf("\t0");
		mini=min(count,rate);
		printf("\t\t%d",mini);
		count=count-mini;
		printf("\t\t%d",count);
		printf("\t\t%d\n",drop);
		sleep(1);
	}
}
