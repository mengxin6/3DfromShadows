function plotLineFit(img, topx, topy, botx, boty)
figure;
imshow(img);
hold on
line([topx, botx],[topy, boty],'Color','y');
hold off

end