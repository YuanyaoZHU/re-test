function s = Func_centr(mass,centroid)
%------- 说明 ------
%  mass 质量数组；centroid 重心坐标数组（某一维度）；
%  两个数组的维度必须一致
 s = 0.0;
 Total_mass = sum(mass);
 n_mass = numel(mass);
 n_centroid = numel(centroid);
 if n_mass == n_centroid %  两个数组的维度必须一致
     temp = 0.0;
    for i=1:n_centroid
       temp = temp + mass(i)*centroid(i);
    end
    s = temp/Total_mass;

 else
     pause('质量与坐标维度不一致！');
 end

end