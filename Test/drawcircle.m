function id = drawcircle(Circ, position, isActivated)
    id_ = mgladdcircle(Circ.Color, Circ.Size);      % add a circle
    mglactivategraphic(id_, isActivated)
    mglsetproperty(id_,'origin', position);              % move the circle to the center
    id = id_;
end