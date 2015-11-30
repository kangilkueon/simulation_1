package GC
  model Customer
    parameter Real mean_interarrive_time(start = 1.0);
    Integer generation_count(start = 0);
    Real generation_time(start = mean_interarrive_time);
    output Boolean event_customer_send(start = false);
    Boolean event1(start = false);
  algorithm
    event_customer_send := false;
    event1 := time >= pre(generation_time);
    when event1 then
      event_customer_send := true;
      generation_count := pre(generation_count) + 1;
      generation_time := pre(generation_time) + mean_interarrive_time;
    end when;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Bitmap(origin = {-55, 62}, extent = {{111, -114}, {-3, 4}}, imageSource = "iVBORw0KGgoAAAANSUhEUgAAAHwAAACECAYAAABS30/KAAAABmJLR0QA/wD/AP+gvaeTAAAEVUlEQVR4nO3dz2sUZxzH8feapdXGtngRjUrpLylGb/4AT+rBQz1Ie+q94MlL8R/opVCoCO2tp17EFhEV9SAICv5CqlQQwf7KqVW0FAmGtKk0bg+z0s26u/PMzPPMM/t8Py94QNjMzHf3nZjJ7mYCIiIiIiIiIlKXVuwBavYqsAOYAiaAR8At4I+YQ4l/24CzwALQ6VuLwDVgX7TpxJsJ4AjwjBdDD1qngMkok0plLeA73EL3rpvAygjzSkWfUjz283Wi/nGlik3Av5QP3gE+qH1qKe0bqsXukJ29yxh4CZilevAOsLHm2YNbFnuAAN4DXve0r+2e9tMYKQaf8riv9R731QgpBpcRUgz+wOO+7nvclwTSBh7j56TtjZpnl5KOUj32ndqnltI2Ak/REy+mfEH52Oex99Lx2JsAzlE89l1gVYR5xYM28CXuL4+ewd+TNhKR3gDRZe37lN7iJLak9BW+AthA9lXs0wLwG/DE836loNeAj4GTwJ/4eWZt1JoDLgCf4PcFGsnRBg6Sfd8NHXnYmgc+w///JtJnDXCdeKH71wywJeg9NmyK7AGOHbl/zZL92CceTQK3iR932HpIdsIonhwmftS8dT7YvTfmHaq/8lXXej/QY2DKV8QP6bouBXoMzGiRvc0odkjXtUj2k0RjNf09bZsZryc5lgF7Yg8xStODvxV7gBLejj3AKE0Pvjb2ACU0euamB38l9gAlNPr3y5seXDxrxx6gojngZ2A5MB34WDNkT6NuAFYHPlYw4/4V/gOwFfiwhmMd6h7r2xqOFcy4B5eCFNwYBTdGwY1JJXgn9gDjIpXg4kjBjVFwYxTcGAU3JpXgOkt3lEpwcaTgxii4MQpuTCrBddLmKJXg4kjBjVFwYxTcGAU3JpXgOkt3lEpwcaTgxii4MU0P/nfO7X/VMsVSCzm3580cVdOD38y5/UYtUyz1fcXbJccpBl9e41f+/yvAbw75GJ9rf/dYEwy/OOBdsl9slAomgWMsfWCvsPQvDtUZHLKL6Pf/IZ3LjNflSRpvDbALeHfAbUWCPwU+767fC2zXG/y5dcDu7vGlRkWCz/dsd63AdoOCj52mn7SJZ6kE11OrjlIJLo4U3BgFN0bBjVFwY1IJrrN0R6kEF0cKboyCG6PgxqQSXCdtjlIJLo4U3BgFN0bBjVFwY1IJrrN0R6kEF0cKboyCG6Pgxii4MakE11m6o1SCiyMFN0bBjVFwY1IJrpM2R6kEF0cKboyCG6Pgxii4MakE11m6o1SCiyMFN0bBjVFwYxTcmFSCF7mMdu+VGItc6no+/0OaL5Xgs8BDx4/9seffPzlu0wHuFZpIgjuM2zVTD/Rss9Nxm4u13AMpZBXwC6PDXQbafdt9nbPNE2A6/PhSxnqGX7z+JNl1zvu1gSPA4oBtZoCtwaeuUSv2AAG0gH3AXuBlYA44DVzN2W4a+AhYDTwj+8Q5DvwTbFIRERERERERSdp/5PL935/nB3oAAAAASUVORK5CYII=")}));
  end Customer;

  package Server
    model JVM
      parameter Real eden_limit_level(start = 100);
      Boolean event1(start = false);
      Boolean survive_flag(start = false);
      Real require_eden(start = 0.0);
      Real total_eden(start = 0.0);
      Real survive_remain(start = 0.0);
      Modelica.Blocks.Interfaces.BooleanInput event_user_come annotation(Placement(visible = true, transformation(origin = {-96, 14}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {-86, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput event_user_out annotation(Placement(visible = true, transformation(origin = {-116, -26}, extent = {{22, -22}, {-22, 22}}, rotation = 0), iconTransformation(origin = {-90, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput eden_level annotation(Placement(visible = true, transformation(origin = {88, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {98, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput survive0_level annotation(Placement(visible = true, transformation(origin = {88, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {96, 34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput survive1_level annotation(Placement(visible = true, transformation(origin = {88, 8}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {94, 6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput old_level annotation(Placement(visible = true, transformation(origin = {88, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {92, -18}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput perm_level annotation(Placement(visible = true, transformation(origin = {88, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {96, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput eden_out annotation(Placement(visible = true, transformation(origin = {62, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {72, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput survive0_out annotation(Placement(visible = true, transformation(origin = {60, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput survive1_out annotation(Placement(visible = true, transformation(origin = {58, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {58, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput old_out annotation(Placement(visible = true, transformation(origin = {54, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {54, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput perm_out annotation(Placement(visible = true, transformation(origin = {52, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {52, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      event1 := edge(event_user_come);
      event_user_out := false;
      when event1 then
        require_eden := 30.0;
        eden_out := eden_level;
        if eden_limit_level < require_eden + eden_out then
          eden_out := eden_level * 0.2;
          if survive_flag then
            survive1_out := survive0_level * 0.2 + eden_level - eden_out;
            survive0_out := 0;
            survive_remain := check_servive_level(survive1_out, 50);
            if survive_remain > 0 then
              survive1_out := survive_remain;
            end if;
          else
            survive0_out := survive1_level * 0.2 + eden_level - eden_out;
            survive1_out := 0;
            survive_remain := check_servive_level(survive0_out, 50);
            if survive_remain > 0 then
              survive0_out := survive_remain;
            end if;
          end if;
          survive_flag := not survive_flag;
          if survive_remain > 0 then
            old_out := old_level + survive_remain;
            survive_remain := check_servive_level(old_out, 20);
            if survive_remain > 0 then
              old_out := survive_remain;
            end if;
          else
            old_out := old_level;
          end if;
        end if;
        total_eden := pre(total_eden) + require_eden;
        perm_out := perm_level;
        eden_out := require_eden + eden_out;
        event_user_out := true;
      end when;
    end JVM;

    model Eden
      parameter Real eden_size(start = 100.0);
      Real current_level(start = 0.0);
      Boolean event1;
      Modelica.Blocks.Interfaces.RealInput eden_in annotation(Placement(visible = true, transformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput eden_out annotation(Placement(visible = true, transformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      event1 := eden_in <> pre(eden_in);
      when event1 then
        current_level := eden_in;
        eden_out := current_level;
        event1 := false;
      end when;
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Eden;

    model Survive
      parameter Real survive_size(start = 100.0);
      Real current_level(start = 0.0);
      Boolean event1;
      Modelica.Blocks.Interfaces.RealInput survive_in annotation(Placement(visible = true, transformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput survive_out annotation(Placement(visible = true, transformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      event1 := survive_in <> pre(survive_in);
      when event1 then
        current_level := survive_in;
        survive_out := current_level;
        event1 := false;
      end when;
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Survive;

    model Old
      parameter Real old_size(start = 100.0);
      Real current_level(start = 0.0);
      Boolean event1;
      Modelica.Blocks.Interfaces.RealInput old_in annotation(Placement(visible = true, transformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput old_out annotation(Placement(visible = true, transformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      event1 := old_in <> pre(old_in);
      when event1 then
        current_level := old_in;
        old_out := current_level;
        event1 := false;
      end when;
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Old;

    model Perm
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Perm;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Server;

  package TestCase
    model test
      Server.Eden eden1(eden_size = 100.0) annotation(Placement(visible = true, transformation(origin = {48, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Server.JVM jVM1 annotation(Placement(visible = true, transformation(origin = {0, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Server.Survive survive0 annotation(Placement(visible = true, transformation(origin = {48, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Server.Survive survive1 annotation(Placement(visible = true, transformation(origin = {48, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Server.Old old1 annotation(Placement(visible = true, transformation(origin = {48, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Customer customer1 annotation(Placement(visible = true, transformation(origin = {-66, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      eden1.eden_in = pre(jVM1.eden_out);
      survive0.survive_in = pre(jVM1.survive0_out);
      survive1.survive_in = pre(jVM1.survive1_out);
      old1.old_in = pre(jVM1.old_out);
      jVM1.eden_level = pre(eden1.eden_out);
      jVM1.event_user_come = pre(customer1.event_customer_send);
      jVM1.survive0_level = pre(survive0.survive_out);
      jVM1.survive1_level = pre(survive1.survive_out);
      jVM1.old_level = pre(old1.old_out);
      jVM1.perm_level = 0;
    end test;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end TestCase;

  function check_servive_level
    input Real servive_level;
    input Real servive_limit;
    output Real remainder;
  algorithm
    remainder := 0;
    if servive_level > servive_limit then
      remainder := servive_level * 0.2;
    end if;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end check_servive_level;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end GC;