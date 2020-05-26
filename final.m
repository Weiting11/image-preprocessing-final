clear;
close all;
output = fopen('output.txt','w');
C=[185 300 480 800];
I=zeros(1,20);%�ΨӦs�C�i�ϼаO���ƶq�s��

for start=1:20
    Name=sprintf('%03d.jpg',start);
    im=imread(Name);
    fprintf(output,'%s\r\n',Name);
    
    %%%%�v���e�B�z%%%%
    g=rgb2gray(im);
    g1=g(185:300,480:800);
    h=histeq(g1);%histogram equalization
    pre = [-1 0 1;-1 0 1;-1 0 1];
    p1=imfilter(h,pre);%��t����
    b1=p1 >128;%�G���v��
    f1=fspecial('average',3);
    F=imfilter(b1,f1);%LPF
    F2=imfilter(F,f1);
    
    st1=ones(1,8);
    st2=ones(8,8);
    D1=imdilate(F2,st1);%����
    CL1=imclose(D1,st2);%����
    
    %%%%�v���аO%%%%
    [label,num]=bwlabel(CL1,8);
    for i=1:num
        [y1,x1]=find(label==i);
        ratio=(max(x1)-min(x1))/(max(y1)-min(y1));%���P���e��
        area=length(x1);
        
        if ratio>2.0 && ratio<4.3 && area>2000 && area<4000
            j=i;
            subplot(2,1,1),imshow(CL1),title('���');
            subplot(2,1,2),imshow(label==j),title('���P�d��'),figure;
            min_x=min(x1)+5;
            min_y=min(y1);
            max_x=max(x1)-5;
            max_y=max(y1);
        end
    end
    
    x2=2;
    y2=1;
    Dy= C(1) + min_y;
    Dx= C(3) + min_x;
    license_seg=g(C(1)+min_y:C(1)+max_y,C(3)+min_x:C(3)+max_x);%�q�Ƕ����έ��ұo�쪺���^�����P
    M1=50;%�֭�
    b2= license_seg < M1;%�ন�G���v��
    
    h2=histeq(license_seg);%���ƨ��P
    M1=100;%�֭�
    b2=h2 < M1;%���ƫ���G��
    
    %%%%���P���v���аO%%%%
    [label2,num2]=bwlabel(b2,4);
    for i=1:num2
        [y1,x1]=find(label2==i);
        ratio2 = (max(x1) - min(x1)) /(max(y1) - min(y1)) ;
        ratio_y3= (max(y1) - min(y1)) / size(label2,1);  
         area = (max(x1) - min(x1)) .* (max(y1) - min(y1)) ;
         if   area>128 && ratio2<0.7 &&  ratio_y3<0.95
             j= i;
             I(start) = I(start)+1;
             min_x = min(x1) +Dx-2;
             max_x = max(x1) +Dx-2;
             min_y = min(y1) +Dy-2;
             max_y = max(y1) +Dy-2;
             fprintf(output,'%d %d %d %d\r\n',min_x,min_y,max_x,max_y);
             subplot(1,8,I(start)),imshow(g(min_y:max_y,min_x:max_x));
         end 
    end
    figure;
end   

