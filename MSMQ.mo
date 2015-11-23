package SSSQ
  package SSSQ_Model
    model End_Model
      input Boolean event_in1;
      parameter Integer Number_Of_Customer(start = 1);
      Integer Finish_Count(start = 0, fixed = true);
      Boolean Event1;
    algorithm
      Event1 := edge(event_in1);
      when Event1 then
        Finish_Count := pre(Finish_Count) + 1;
        if Finish_Count == Number_Of_Customer then
          terminate("simulation is finish");
        end if;
      end when;
      annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Ellipse(fillColor = {255, 255, 255}, lineThickness = 15, extent = {{-85, 85}, {85, -85}}, endAngle = 360), Text(extent = {{-100, 20}, {100, -20}}, textString = "END", fontSize = 100, textStyle = {TextStyle.Bold})}));
    end End_Model;

    model Start_Model
      parameter Real Mean_Interarrive_Time(start = 1.0);
      parameter Integer Number_Of_Customer(start = 1);
      Integer Generation_Count(start = 0, fixed = true);
      Real Generation_Time(start = Mean_Interarrive_Time, fixed = true);
      output Boolean event_out1(start = false);
      Boolean Event1(start = false);
    algorithm
      event_out1 := false;
      Event1 := time >= pre(Generation_Time);
      when Event1 then
        event_out1 := true;
        Generation_Count := pre(Generation_Count) + 1;
        if Generation_Count < Number_Of_Customer then
          Generation_Time := pre(Generation_Time) + Mean_Interarrive_Time;
        end if;
      end when;
    end Start_Model;

    model Big_Queue
      input Boolean event_in1, event_in2;
      output Boolean event_out1;
      parameter Integer queue_size(start = 3);
      Integer[queue_size] queue_counts;
      Integer selected_queue;
      Boolean signal_flag(start = true, fixed = true);
      Boolean Event1, Event2;
    algorithm
      event_out1 := false;
      Event1 := edge(event_in1);
      Event2 := edge(event_in2);
      when {Event1, Event2} then
        if Event1 then
          if signal_flag == false then
            selected_queue := Get_Min(queue_size, queue_counts);
            queue_counts[selected_queue] := queue_counts[selected_queue] + 1;
          end if;
          if signal_flag == true then
            event_out1 := true;
            signal_flag := false;
          end if;
        end if;
        if Event2 then
          selected_queue := Get_Max(queue_size, queue_counts);
          queue_counts[selected_queue] := queue_counts[selected_queue] - 1;
          if queue_counts[selected_queue] < 0 then
            queue_counts[selected_queue] := 0;
            signal_flag := false;
          end if;
          if signal_flag == true then
            event_out1 := true;
            signal_flag := false;
          end if;
        end if;
      end when;
    end Big_Queue;

    model Big_Server
      input Boolean event_in1;
      output Boolean event_out1, event_out2;
      parameter Integer server_count(start = 4);
      parameter Real[server_count] Mean_Server_Time;
      discrete Boolean[server_count] Server_Busy;
      discrete Real[server_count] Server_Time;
      Boolean Event1, Event2;

      function Out_Check
        input Real a;
        input Real b;
        output Boolean c;
      algorithm
        c := if a <> b then true else false;
      end Out_Check;
    protected
      Real Server_Finish_Count(start = 0, fixed = true);
      Real min_server_time(start = 0);
      Integer i(start = 0);
      Integer idx(start = 0);
    algorithm
      Event1 := edge(event_in1);
      Event2 := time > min_server_time;
      event_out1 := false;
      event_out2 := false;
      when {Event1, Event2} then
        if Event1 then
          i := 0;
          while i <> server_count loop
            if not pre(Server_Busy[i]) then
              Server_Busy[i] := true;
              Server_Time[i] := time + Mean_Server_Time[i];
              event_out1 := true;
              idx := Get_Min_Time(server_count, Server_Time);
              min_server_time := Server_Time[idx];
              break;
            end if;
          end while;
        end if;
        if Event2 then
          Server_Busy[idx] := false;
          event_out1 := false;
          Server_Finish_Count := pre(Server_Finish_Count) + 1;
          event_out2 := true;
        end if;
      end when;
      annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {85, 255, 255}, fillPattern = FillPattern.CrossDiag, lineThickness = 2, extent = {{-100, 60}, {100, -60}}), Text(extent = {{-100, 20}, {100, -20}}, textString = "Server", fontSize = 100, textStyle = {TextStyle.Bold})}));
    end Big_Server;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(extent = {{-100, 100}, {100, -100}}, textString = "M", fontSize = 500, textStyle = {TextStyle.Bold})}));
  end SSSQ_Model;

  package Example
    model MultiServerMultiQueue
      SSSQ_Model.Start_Model start_Model1(Mean_Interarrive_Time = 1.0, Number_Of_Customer = 1000) annotation(Placement(visible = true, transformation(origin = {-85, 9}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
      SSSQ_Model.End_Model end_Model1(Number_Of_Customer = 1000) annotation(Placement(visible = true, transformation(origin = {66, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ_Model.Big_Server big_Server1(server_count = 4, Mean_Server_Time = {1.0, 1.0, 1.0, 1.0}) annotation(Placement(visible = true, transformation(origin = {6, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ_Model.Big_Queue big_Queue1(queue_size = 3) annotation(Placement(visible = true, transformation(origin = {-44, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      end_Model1.event_in1 := pre(big_Server1.event_out2);
      big_Queue1.event_in2 := pre(big_Server1.event_out1);
      big_Server1.event_in1 := pre(big_Queue1.event_out1);
      big_Queue1.event_in1 := pre(start_Model1.event_out1);
    end MultiServerMultiQueue;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(extent = {{-100, 100}, {100, -100}}, textString = "M", fontSize = 200, textStyle = {TextStyle.Bold})}));
  end Example;

  function Get_Min
    input Integer arr_size;
    input Integer[arr_size] arr;
    output Integer result;
  protected
    Integer k(start = 0);
    Integer min(start = 10000);
  algorithm
    while k <> arr_size loop
      if min > arr[k] then
        result := k;
        min := arr[k];
      end if;
      k := k + 1;
    end while;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Get_Min;

  package MSMQ_Model
    model StartModel
      function Out_Check
        input Real a;
        input Real b;
        output Boolean c;
      algorithm
        c := if a <> b then true else false;
      end Out_Check;

      parameter Real Mean_Interarrive_Time(start = 1.0);
      parameter Integer Number_Of_Customer(start = 1);
      parameter Integer Queue_Size(start = 3);
      Integer selected_queue(start = 0);
      Integer Generation_Count(start = 0, fixed = true);
      Real Generation_Time(start = Mean_Interarrive_Time, fixed = true);
      Modelica.Blocks.Interfaces.BooleanOutput signal_to_queue[3] annotation(Placement(visible = true, transformation(origin = {77, 51}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {70, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerInput num_of_queue[3] annotation(Placement(visible = true, transformation(origin = {60, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {90, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    algorithm
      when time >= Generation_Time then
        Generation_Count := pre(Generation_Count) + 1;
        if Generation_Count < Number_Of_Customer then
          Generation_Time := pre(Generation_Time) + Mean_Interarrive_Time;
        end if;
      end when;
    equation
      signal_to_queue[0] = false;
      signal_to_queue[1] = false;
      signal_to_queue[2] = false;
      if Out_Check(Generation_Count, pre(Generation_Count)) then
        selected_queue = Get_Min(Queue_Size, num_of_queue);
        signal_to_queue[selected_queue] = true;
      end if;
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end StartModel;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end MSMQ_Model;

  function Get_Max
    input Integer arr_size;
    input Integer[arr_size] arr;
    output Integer result;
  protected
    Integer k(start = 0);
    Integer max(start = 0);
  algorithm
    max := 0;
    while k <> arr_size loop
      if max < arr[k] then
        result := k;
        max := arr[k];
      end if;
      k := k + 1;
    end while;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Get_Max;

  function Find_Not_Busy
    input Integer arr_size;
    input Boolean[arr_size] arr;
    output Integer result;
  protected
    Integer k(start = 0);
  algorithm
    while k <> arr_size loop
      if arr[k] <> true then
        result := k;
      end if;
      k := k + 1;
    end while;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Find_Not_Busy;

  function Get_Min_Time
    input Integer arr_size;
    input Real[arr_size] arr;
    output Integer result;
  protected
    Integer k(start = 0);
    Real min(start = 10000);
  algorithm
    while k <> arr_size loop
      if min > arr[k] then
        min := arr[k];
        result := k;
      end if;
      k := k + 1;
    end while;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Get_Min_Time;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end SSSQ;