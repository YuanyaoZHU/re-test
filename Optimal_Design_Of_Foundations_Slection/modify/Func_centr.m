function s = Func_centr(mass,centroid)
%------- ˵�� ------
%  mass �������飻centroid �����������飨ĳһά�ȣ���
%  ���������ά�ȱ���һ��
 s = 0.0;
 Total_mass = sum(mass);
 n_mass = numel(mass);
 n_centroid = numel(centroid);
 if n_mass == n_centroid %  ���������ά�ȱ���һ��
     temp = 0.0;
    for i=1:n_centroid
       temp = temp + mass(i)*centroid(i);
    end
    s = temp/Total_mass;

 else
     pause('����������ά�Ȳ�һ�£�');
 end

end