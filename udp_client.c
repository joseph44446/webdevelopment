
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>

int main(){
  int clientSocket, portNum, nBytes;
  char send_buffer[1024]="", recv_buffer[1024]="";
  struct sockaddr_in serverAddr;
  socklen_t addr_size;

 
  clientSocket = socket(PF_INET, SOCK_DGRAM, 0);

 
  serverAddr.sin_family = AF_INET;
  serverAddr.sin_port = htons(1234);
  serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
  memset(serverAddr.sin_zero, '\0', sizeof (serverAddr.sin_zero));  

  
  addr_size = sizeof (serverAddr);

  while(1){
    printf("Type a sentence to send to server:\n");
    fgets(send_buffer,1024,stdin);

    printf("sent ---> %s",send_buffer);

    nBytes = strlen(send_buffer) + 1;
    
   
    sendto(clientSocket,send_buffer,nBytes,0,(struct sockaddr *)&serverAddr,addr_size);

  
    nBytes = recvfrom(clientSocket,recv_buffer,1024,0,NULL, NULL);

    printf("Received <--- %s\n",recv_buffer);

  }

  return 0;
}
