package SSSQ
  package SSSQ_Model
    model Queue
      SSSQ.SSSQ_Event_port.Event_In event_in1 annotation(Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Event_port.Event_Out event_out1 annotation(Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      discrete Integer Queue_Count(start = 0, fixed = true);
      SSSQ.SSSQ_Event_port.Event_In event_in2 annotation(Placement(visible = true, transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ_Event_port.Event_Out event_Out1 annotation(Placement(visible = true, transformation(origin = {-94, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-94, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      when event_in1.signal then
        Queue_Count := Queue_Count + 1;
      end when;
      when event_in2.signal then
        Queue_Count := Queue_Count - 1;
        if Queue_Count < 0 then
          Queue_Count := 0;
        end if;
      end when;
    equation
      event_out1.signal = if pre(Queue_Count) > 0 then true else false;
      event_Out1.signal = Queue_Count;
      //if pre(Queue_Count) == 0 and event_in1.signal or pre(Queue_Count) > 0 then true else false;
      annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {0, 255, 0}, fillPattern = FillPattern.CrossDiag, lineThickness = 2, extent = {{-100, 60}, {100, -60}}), Text(extent = {{-100, 20}, {100, -20}}, textString = "Queue", fontSize = 100, textStyle = {TextStyle.Bold})}));
    end Queue;

    model End_Model
      SSSQ.SSSQ_Event_port.Event_In event_in1 annotation(Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      parameter Integer Number_Of_Customer(start = 1);
      Integer Finish_Count(start = 0, fixed = true);
      //  Real Finish_Time(start = 0, fixed = true);
    algorithm
      when event_in1.signal then
        Finish_Count := pre(Finish_Count) + 1;
        if Finish_Count == Number_Of_Customer then
          terminate("simulation is finish");
        end if;
      end when;
      annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Ellipse(fillColor = {255, 255, 255}, lineThickness = 15, extent = {{-85, 85}, {85, -85}}, endAngle = 360), Text(extent = {{-100, 20}, {100, -20}}, textString = "END", fontSize = 100, textStyle = {TextStyle.Bold})}));
    end End_Model;

    model Start_Model
      function Out_Check
        input Real a;
        input Real b;
        output Boolean c;
      algorithm
        c := if a <> b then true else false;
        annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
      end Out_Check;

      parameter Real Mean_Interarrive_Time(start = 1.0);
      parameter Integer Number_Of_Customer(start = 1);
      parameter Integer Queue_Size(start = 3);
      Integer selected_queue(start = 0);
      Integer Generation_Count(start = 0, fixed = true);
      Real Generation_Time(start = Mean_Interarrive_Time, fixed = true);
      SSSQ.SSSQ_Event_port.Event_Out event_out[Queue_Size] annotation(Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ_Event_port.Event_In event_In[Queue_Size] annotation(Placement(visible = true, transformation(origin = {94, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {94, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      when time >= Generation_Time then
        Generation_Count := pre(Generation_Count) + 1;
        if Generation_Count < Number_Of_Customer then
          Generation_Time := pre(Generation_Time) + Mean_Interarrive_Time;
        end if;
      end when;
    equation
      if Out_Check(Generation_Count, pre(Generation_Count)) then
        selected_queue = Get_Min(Queue_Size, event_In);
        event_out[selected_queue] = true;
      end if;
      //event_out1.signal = Out_Check(Generation_Count, pre(Generation_Count));
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(extent = {{-100, 20}, {100, -20}}, textString = "START", fontSize = 100, textStyle = {TextStyle.Bold}), Ellipse(lineThickness = 15, extent = {{-85, 85}, {85, -85}}, endAngle = 360)}), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Start_Model;

    model Server
      SSSQ.SSSQ_Event_port.Event_Out event_out1 annotation(Placement(visible = true, transformation(origin = {-100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Event_port.Event_In event_in1 annotation(Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      parameter Real Mean_Server_Time(start = 1.0);
      discrete Boolean Server_Busy(start = false, fixed = true);
      discrete Real Server_Time(start = 0.0, fixed = true);

      function Out_Check
        input Real a;
        input Real b;
        output Boolean c;
      algorithm
        c := if a <> b then true else false;
      end Out_Check;

      SSSQ.SSSQ_Event_port.Event_Out event_out2 annotation(Placement(visible = true, transformation(origin = {100, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    protected
      Real Serve_Finish_Count(start = 0, fixed = true);
    algorithm
      when event_in1.signal and not pre(Server_Busy) then
        Server_Busy := true;
        Server_Time := time + Mean_Server_Time;
        event_out1.signal := true;
      end when;
      when time >= Server_Time then
        Server_Busy := false;
        event_out1.signal := false;
        Serve_Finish_Count := pre(Serve_Finish_Count) + 1;
      end when;
    equation
      event_out2.signal = Out_Check(Serve_Finish_Count, pre(Serve_Finish_Count));
      annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {85, 255, 255}, fillPattern = FillPattern.CrossDiag, lineThickness = 2, extent = {{-100, 60}, {100, -60}}), Text(extent = {{-100, 20}, {100, -20}}, textString = "Server", fontSize = 100, textStyle = {TextStyle.Bold})}));
    end Server;

    model Middle_Model
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Middle_Model;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(extent = {{-100, 100}, {100, -100}}, textString = "M", fontSize = 500, textStyle = {TextStyle.Bold})}));
  end SSSQ_Model;

  package SSSQ_Event_port
    connector Event_In " "
      input Boolean signal(start = false, fixed = true);
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-100, 100}, {100, -100}})}), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-45, 45}, {45, -45}}), Text(origin = {0, 70}, extent = {{-100, 15}, {100, -15}}, textString = "Pin_name", fontSize = 100, textStyle = {TextStyle.Bold})}));
    end Event_In;

    connector Event_Out
      output Boolean signal(start = false, fixed = true);
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-100, 100}, {100, -100}})}), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-45, 45}, {45, -45}}), Text(origin = {0, 70}, extent = {{-100, 15}, {100, -15}}, textString = "Pin_name", fontSize = 100, textStyle = {TextStyle.Bold})}));
    end Event_Out;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end SSSQ_Event_port;

  package Example
    model Single_Server_Single_Queue
      SSSQ.SSSQ_Model.Start_Model start_model1(Mean_Interarrive_Time = 1.0, Number_Of_Customer = 1000) annotation(Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Model.Queue queue1 annotation(Placement(visible = true, transformation(origin = {-20, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Model.End_Model end_model1(Number_Of_Customer = 1000) annotation(Placement(visible = true, transformation(origin = {60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Model.Server server1(Mean_Server_Time = 1.5) annotation(Placement(visible = true, transformation(origin = {20, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(server1.event_out2, end_model1.event_in1) annotation(Line(points = {{30, 20}, {50.1433, 20}, {50.1433, 19.7708}, {50.1433, 19.7708}}));
      connect(queue1.event_in2, server1.event_out1) annotation(Line(points = {{-10, 16}, {10.6017, 16}, {10.6017, 16.0458}, {10.6017, 16.0458}}));
      connect(queue1.event_out1, server1.event_in1) annotation(Line(points = {{-10, 24}, {10.3152, 24}, {10.3152, 24.3553}, {10.3152, 24.3553}}));
      connect(start_model1.event_out1, queue1.event_in1) annotation(Line(points = {{-50, 20}, {-29.5129, 20}, {-29.5129, 19.4842}, {-29.5129, 19.4842}}));
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Single_Server_Single_Queue;

    model Tandem
      SSSQ.SSSQ_Model.Start_Model start_model1(Mean_Interarrive_Time = 1.0, Number_Of_Customer = 1000) annotation(Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Model.Queue queue1 annotation(Placement(visible = true, transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Model.Server server1(Mean_Server_Time = 1.5) annotation(Placement(visible = true, transformation(origin = {40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Model.Queue queue2 annotation(Placement(visible = true, transformation(origin = {40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      SSSQ.SSSQ_Model.Server server2(Mean_Server_Time = 3) annotation(Placement(visible = true, transformation(origin = {0, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      SSSQ.SSSQ_Model.End_Model end_model1(Number_Of_Customer = 1000) annotation(Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    equation
      connect(server2.event_out2, end_model1.event_in1) annotation(Line(points = {{-10, -20}, {-30.3725, -19.8281}, {-30.3725, -19.8281}, {-30, -20}}));
      connect(queue2.event_out1, server2.event_in1) annotation(Line(points = {{30, -24}, {9.74212, -23.8281}, {9.74212, -23.8281}, {10, -24}}));
      connect(queue2.event_in2, server2.event_out1) annotation(Line(points = {{30, -16}, {10.0287, -15.8281}, {10.0287, -15.8281}, {10, -16}}));
      connect(server1.event_out2, queue2.event_in1) annotation(Line(points = {{50, 20}, {61.6046, 20.1719}, {61.6046, -18.9112}, {50.4298, -18.9112}, {50.4298, -19.8281}, {50, -20}}));
      connect(queue1.event_in2, server1.event_out1) annotation(Line(points = {{10, 16}, {29.5129, 16.1719}, {29.5129, 16.1719}, {30, 16}}));
      connect(queue1.event_out1, server1.event_in1) annotation(Line(points = {{10, 24}, {30.086, 24.1719}, {30.086, 24.1719}, {30, 24}}));
      connect(start_model1.event_out1, queue1.event_in1) annotation(Line(points = {{-30, 20}, {-10.0287, 20.1719}, {-10.0287, 20.1719}, {-10, 20}}));
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Tandem;

    model test_case
      SSSQ.SSSQ_Model.Start_Model start_model1(Mean_Interarrive_Time = 1.0, Number_Of_Customer = 100) annotation(Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Model.Queue queue1 annotation(Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Model.Server server1(Mean_Server_Time = 0.5) annotation(Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ.SSSQ_Model.End_Model end_model1(Number_Of_Customer = 100) annotation(Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(server1.event_out2, end_model1.event_in1) annotation(Line(points = {{50, 0}, {70.318, 0}, {70.318, -0.706714}, {70.318, -0.706714}}));
      connect(queue1.event_in2, server1.event_out1) annotation(Line(points = {{10, -4}, {28.6219, -4}, {28.6219, -3.53357}, {28.6219, -3.53357}}));
      connect(queue1.event_out1, server1.event_in1) annotation(Line(points = {{10, 4}, {28.6219, 4}, {28.6219, 3.88693}, {28.6219, 3.88693}}));
      connect(start_model1.event_out1, queue1.event_in1) annotation(Line(points = {{-30, 0}, {-10.9541, 0}, {-10.9541, -0.353357}, {-10.9541, -0.353357}}));
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end test_case;

    model MultiServerMultiQueue
      SSSQ_Model.Start_Model start_Model1 annotation(Placement(visible = true, transformation(origin = {-69, 69}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
      SSSQ_Model.Queue queue1[n] annotation(Placement(visible = true, transformation(origin = {34, 60}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
    end MultiServerMultiQueue;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(extent = {{-100, 100}, {100, -100}}, textString = "M", fontSize = 200, textStyle = {TextStyle.Bold})}));
  end Example;

  function Get_Min
    input Integer arr_size;
    input Integer[arr_size] arr;
    output Integer result;
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
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end SSSQ;