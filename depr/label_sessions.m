function [session_inds, mouse_sessions] = label_sessions(orientation)

session_inds = {};
session_inds{1} = 1;
session = 1;

for i = 2:size(orientation,1)
   if orientation(i-1,:) == orientation(i,:)
      session_inds{session} = [session_inds{session}, i];
   else
      session = session + 1;
      session_inds{session} = [i];
   end
end

mouse_sessions{1} = 1:3:24;
mouse_sessions{2} = 2:3:24;
mouse_sessions{3} = 3:3:24;

end