classdef test_class
    %UNTITLED3 Summary of this class goes here
    %   This class is going to have some simple properties and
    % simple methods as well, only with the matter of learn hoy to use OOP
    % in MATLAB.

    properties
        arrNum
    end

    methods
        function obj = test_class(arrNum)
            %UNTITLED3 Construct an instance of this class
            %   Detailed explanation goes here
            obj.arrNum = arrNum;
        end

        function suma = add(obj)
           suma = sum(obj.arrNum);
        end

        function resta = subst(obj)
           resta = obj.arrNum(1)-obj.arrNum(2);
        end
    
        function mult = x(obj)
           mult = prod(obj.arrNum);
        end
    end
end