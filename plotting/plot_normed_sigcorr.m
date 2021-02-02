function [] = plot_normed_sigcorr(sig_normed, save)

   figure()
   set(gcf,'Position', [100   517   458   427])
   
   %subplot(1,2,1)
   scatter3(sig_normed(1,:), sig_normed(2,:), sig_normed(3,:));
   hold on
   
   if any(any(sig_normed < 0))
      xlim([-1,1])
      ylim([-1,1])
      zlim([-1,1])
   else
      xlim([0,1])
      ylim([0,1])
      zlim([0,1])
   end

   [sphere_x,sphere_y,sphere_z] = sphere(100);
   color = ones(length(sphere_x));
   sphere_surf = surf(sphere_x,sphere_y,sphere_z, 'LineStyle', 'none', 'FaceAlpha', 0.3);
   
   diam = zeros(3,2);
   diam(:,1) = -[1;1;1]';
   diam(:,2) =  [1;1;1]';
   diam = diam./norm(diam(:,1));
   
   plot3(diam(1,:), diam(2,:), diam(3,:), 'ko','LineWidth',2)
   
   title('Normed Signal Responses by Neuron')
   xlabel('S1 Response')
   ylabel('S2 Response')
   zlabel('S3 Response')
   
   set(gca, 'CameraPosition', [6.9846    2.3716    5.9265])
   
   
   %subplot(1,2,2)
   
   if save
      saveas(gcf,'Normed-sig-corr.png');
      saveas(gcf,'Normed-sig-corr.fig');
   end

end