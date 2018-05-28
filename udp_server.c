
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(){
  int udpSocket, nBytes;
  char send_buffer[1024]="ACK", recv_buffer[1024]="";

  struct sockaddr_in serverAddr, clientAddr;
  struct sockaddr_storage serverStorage;

  socklen_t addr_size, client_addr_size;
  int i;

 
  udpSocket = socket(PF_INET, SOCK_DGRAM, 0);

  
  serverAddr.sin_family = AF_INET;
  serverAddr.sin_port = htons(1234);
  serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
  memset(serverAddr.sin_zero, '\0', sizeof (serverAddr.sin_zero));  

  
  bind(udpSocket, (struct sockaddr *) &serverAddr, sizeof(serverAddr));

  addr_size = sizeof (serverStorage);

  printf("Server is listening on 127.0.0.1:8899");

  while(1){
    
    nBytes = recvfrom(udpSocket,recv_buffer,1024,0,(struct sockaddr *)&serverStorage, &addr_size);

  	printf("Received message : %s", recv_buffer);
  	printf("ACK sent for %s \n", recv_buffer);

   
    sendto(udpSocket,send_buffer,nBytes,0,(struct sockaddr *)&serverStorage,addr_size);
  }

  return 0;
}
