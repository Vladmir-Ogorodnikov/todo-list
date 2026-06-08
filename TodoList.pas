uses Crt;
  
type 
   TTask = record 
     Name: string;
     Status: string;
   end;  

var
  Tasks: array of TTask;
  user_input: char;
  menu_active: boolean;  
  i : integer; 
  
  
  


    

procedure Menu(i: integer; pos: boolean := true);
begin
  ClrScr;
  TextColor(15);
  writeln('Выберите пункт меню:           ');
  writeln('                               ');
  writeln('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  if i = 4 then
  begin
    TextColor(2);
    writeln('> Добавить задачу  <              ');
    TextColor(15);    
  end  
  else writeln('  Добавить задачу                ');
  if i = 5 then
  begin
    TextColor(2);
    writeln('> Вывести все задачи <         ');
    TextColor(15);
  end
  else writeln('  Вывести все задачи           ');
  if i = 6 then 
  begin
    TextColor(2);
    writeln('> Отметить задачу выполненной <        ');
    TextColor(15);
  end  
  else writeln('  Отметить задачу выполненной          ');
  if i = 7 then 
  begin
    TextColor(2);
    writeln('> Изменить статус выполненной задачи <     ');
    TextColor(15);
  end
  else writeln('  Изменить статус выполненной задачи       ');
  if i = 8 then
  begin
    TextColor(2);
    writeln('> Удалить задачу <                      ');
    TextColor(15);
  end
  else writeln('  Удалить задачу       ');
  if i = 9 then
  begin
    TextColor(2);
    writeln('> Удалить список задач <                      ');
    TextColor(15);
  end
  else writeln('  Удалить список задач                        ');
  if i = 10 then
  begin
    TextColor(2);
    writeln('> Статистика <                      ');
    TextColor(15);
  end
  else writeln('  Статистика                       ');
  if i = 11 then
  begin
    TextColor(2);
    writeln('> Поиск задач <                      ');
    TextColor(15);
  end
  else writeln('  Поиск задач                       ');
  if i = 12 then
  begin
    TextColor(2);
    writeln('> Выход <                      ');
    TextColor(15);
  end
  else writeln('  Выход                        ');
  writeln('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    
   
      
end;

function parse_status(line : string): string;
var
  status: string;
  position: integer;
begin
  position := Pos('|', line);
  if position > 0 then
    Result := Copy(line, 1, position - 1)  
  else
    Result := line;
  
  
end;

function parse_name(line : string): string;
var
  name : string;
  position_name : integer;
begin
  
  position_name := Pos('|', line);
  if position_name > 0 then
    Result := Copy(line, position_name + 1, Length(line) - position_name)
  else
    Result := line;  
  
end;
  

procedure LoadFile();
var
  f : text;
  new_task : TTask;
  line : string;
  

begin
  if not FileExists('tasks.txt') then 
  Exit;
  assign(f, 'tasks.txt');
  Reset(f);  
  while not(eof(f)) do 
    begin
      readln(f, line);
      SetLength(Tasks, Length(Tasks) + 1);
      new_task.Status := parse_status(line);
      new_task.Name := parse_name(line);
      Tasks[Length(Tasks) - 1] := new_task;
      
      
    end;
  close(f);
 
end;

procedure SaveTasksToFile();
var
  f : text;
  i : integer;
  name_task : string;
  status_task : string;
begin
  assign(f, 'tasks.txt');
  rewrite(f);
  
  for i := 0 to Length(Tasks) - 1 do 
  begin
    name_task := Tasks[i].Name;
    status_task := Tasks[i].Status;
    writeln(f, status_task + '|' + name_task);
  end;
  close(f);
 
end;


procedure add();
  var
    name_task : string;
    task : TTask; 
    
  
  begin 
    user_input := #0;
    ClrScr;
    writeln('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    writeln('Введите название задачи -->   ');
    readln(name_task);
    
    if name_task = '' then 
      writeln('Название задачи не может быть пустым!')
    else
    begin
      task.Name := name_task;
      task.Status := 'Не выполнено';
      SetLength(Tasks, Length(Tasks) + 1);
      Tasks[Length(Tasks) - 1] := task;
      SaveTasksToFile();
      
    end;
    
    
    
    writeln();
    writeln('Нажмите любую клавишу для возврата в меню...');
    ReadKey;
  
  end;
 
procedure done();
var
  number_task : integer;
begin
  user_input := #0;
  ClrScr;
  writeln('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  writeln('Введите номер задачи -->   ');
  readln(number_task);
  
  if (number_task < 1) or (number_task > Length(Tasks)) then 
    writeln('Задача с таким номером не существует!')
  
  else
  begin
    if Tasks[number_task - 1].Status = 'Выполнено' then 
      writeln('Задача уже выполнена!')
    else
    begin
      Tasks[number_task - 1].Status := 'Выполнено';
      writeln('Задача отмечена как выполненная!');
      SaveTasksToFile();
    end;
    
  end;
  writeln();
  writeln('Нажмите любую клавишу для возврата в меню...');
  ReadKey;
  
end;  


procedure undone();
var
  number_task : integer;
begin
  user_input := #0;
  ClrScr;
  writeln('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  writeln('Введите номер задачи -->   ');
  readln(number_task);
  
  if (number_task < 1) or (number_task > Length(Tasks)) then 
    writeln('Задача с таким номером не существует!')
  
  else
  begin
    if Tasks[number_task - 1].Status = 'Не выполнено' then 
      writeln('Задача ещё не выполнена!')
    else
    begin
      Tasks[number_task - 1].Status := 'Не выполнено';
      writeln('Статус задачи изменён!');
      SaveTasksToFile();
    end;
    
  end;
  writeln();
  writeln('Нажмите любую клавишу для возврата в меню...');
  ReadKey;
end; 

procedure stats(is_menu: boolean);
var
  cnt_done: integer := 0;
  cnt_undone : integer := 0;
  i : integer;
begin
  if is_menu then
  ClrScr();
  if Length(Tasks) < 1 then 
    writeln('Список задач пуст')
  else
  begin
   for i := 0 to Length(Tasks) - 1 do 
    begin
      if Tasks[i].Status = 'Выполнено' then 
        cnt_done := cnt_done + 1
      else
        cnt_undone := cnt_undone + 1;
    end; 
    
    writeln('Всего задач:', cnt_done + cnt_undone);
    writeln('Выполненных:', cnt_done);
    writeln('Невыполненных:', cnt_undone);
  end;
  if is_menu then
  begin
    writeln();
    writeln('Нажмите любую клавишу для возврата в меню...');
    ReadKey;
  end;
  
  
  
end;  

procedure delete_task();
var
  number_task : integer;
  i : integer; 
begin
  user_input := #0;
  ClrScr;
  writeln('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  writeln('Введите номер задачи -->   ');
  readln(number_task);
  
  if (number_task < 1) or (number_task > Length(Tasks)) then 
    writeln('Задача с таким номером не существует!')
  else 
  begin
    for i := number_task - 1 to Length(Tasks) - 2 do
    begin
      Tasks[i] := Tasks[i + 1];
    end;
    
    
    SetLength(Tasks, Length(Tasks) - 1);
    
    
    SaveTasksToFile();
    
    writeln('Задача успешно удалена!');
  end;
  
  writeln();
  writeln('Нажмите любую клавишу для возврата в меню...');
  ReadKey;
   
end;   

procedure clear(is_menu : boolean);
var
  has_complete : boolean = false;
  tempTasks: array of TTask;
  confirm: string; 
  i : integer;
begin
  if is_menu then
    ClrScr();
  if Length(Tasks) = 0 then 
  begin
    writeln('Список пуст');
    if is_menu then 
    begin
       writeln();
       writeln('Нажмите любую клавишу для возврата в меню...');
       ReadKey;
    end;
    Exit;
  end;
  
  
  for i := 0 to Length(Tasks) - 1 do 
  begin
    if Tasks[i].Status = 'Выполнено' then 
    begin
      has_complete := true;
      break;
    end;
  end;
  
  if not has_complete then 
  begin
    writeln('В списке нет выполненных задач');
    if is_menu then 
    begin
       writeln();
       writeln('Нажмите любую клавишу для возврата в меню...');
       ReadKey;
    end;
    Exit;
   
  end
  else 
  begin
      writeln('Будут удалены все выполненные задачи');
    writeln('Вы уверены? (y/n)');
    readln(confirm);
    
    while (confirm <> 'y') and (confirm <> 'n') do 
    begin
      writeln('Неверный ввод. Пожалуйста, введите y (да) или n (нет): ');
      readln(confirm);
    end;
    
    if confirm = 'n' then
    begin
      writeln('Операция отменена');
      if is_menu then 
      begin
         writeln();
         writeln('Нажмите любую клавишу для возврата в меню...');
         ReadKey;
      end;
    end
    
    else 
    begin
      SetLength(tempTasks, 0);
      for i := 0 to length(Tasks) - 1 do
      begin
        if Tasks[i].Status <> 'Выполнено' then
        begin
          SetLength(tempTasks, Length(tempTasks) + 1);
          tempTasks[Length(tempTasks) - 1] := Tasks[i];
        end;
      end;
      Tasks := tempTasks;
      SaveTasksToFile();
      writeln('Выполненные задачи успешно удалены!');
      if is_menu then 
      begin
         writeln();
         writeln('Нажмите любую клавишу для возврата в меню...');
         ReadKey;
      end;
    end;
  end;
  
  
  
end;

procedure search(is_menu: boolean);
var
  key: string;
  i : integer;
  is_found : boolean := false;
begin
  if is_menu then
    ClrScr();
  writeln('Введите ключевое слово:');
  readln(key);
  for i := 0 to Length(Tasks) - 1 do 
  begin
    if Pos(LowerCase(key), LowerCase(Tasks[i].Name)) > 0 then 
    begin
      is_found := true;
      writeln(i + 1, '.', Tasks[i].Status + '|' + Tasks[i].Name);
    end;
  end;
  if not is_found then 
    writeln('Задач по данному ключу не найдено');
  
  if is_menu then 
  begin
    writeln();
    writeln('Нажмите любую клавишу для возврата в меню...');
    ReadKey;
  end;
  
  
  
end;    
  
procedure list(is_menu: boolean);
var 
  task: string;
  i : integer;
begin
  if is_menu then
    ClrScr;
  writeln('Список задач');
  writeln('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  
  if (not FileExists('tasks.txt')) or (Length(Tasks) = 0) then 
  begin
    writeln('Список задачи пуст');
  end
  else
  begin
    for i := 0 to Length(Tasks) - 1 do 
      writeln(i + 1, '.', Tasks[i].Status + '|' + Tasks[i].Name);
  end;
  
  if is_menu then
  begin
    writeln();
    writeln('Нажмите любую клавишу для возврата в меню...');
    ReadKey; 
  end;
 
end;    


procedure CommandLine();
var
  command: string;
  task_name : string;
  task : TTask;
  task_number : integer;
  task_number_str : string;
  code : integer;
  i : integer;
begin
  if ParamCount = 0 then Exit; 
  
  command := LowerCase(ParamStr(1));
  if command = 'add' then 
  begin
    if ParamCount < 2 then 
      writeln('Укажите название задачи')
    else 
    begin
      task_name := ParamStr(2);
      for i := 3 to ParamCount do 
      begin
        task_name := task_name + ' ' + ParamStr(i);
      end;
      if task_name = '' then 
        writeln('Ошибка: Название задачи не может быть пустым!')
      else
      begin
        task.Name := task_name;
        task.Status := 'Не выполнено';
        SetLength(Tasks, Length(Tasks) + 1);
        Tasks[Length(Tasks) - 1] := task;
        SaveTasksToFile();
        writeln('Задача успешно добавлена!');
      end;
      
    end;
  end
  else if (command = 'done') or (command = 'undone') or (command = 'delete') then 
    if ParamCount < 2 then 
      begin
        writeln('Укажите номер задачи');
        Exit;
      end  
       
    else 
    begin
      task_number_str := ParamStr(2);
      Val(task_number_str, task_number, code);
      if code <> 0 then
        begin 
        writeln('Ошибка: Неверный формат номера. Ожидается целое число.');
        Exit;
        end;
      if (task_number <= 0) or (task_number > Length(Tasks)) then 
      begin
        begin
        writeln('Задачи с номером', task_number, 'не существует');
        Exit;
        end;
      end;
      if command = 'done' then
      begin
        if Tasks[task_number - 1].Status = 'Выполнено' then
          Writeln('Задача уже выполнена!')
        else
        begin
          Tasks[task_number - 1].Status := 'Выполнено';
          SaveTasksToFile();
          Writeln('Задача ', task_number, ' отмечена как выполненная.');
        end;
      end
      else if command = 'undone' then
      begin
        if Tasks[task_number - 1].Status = 'Не выполнено' then
          Writeln('Задача уже не выполнена!')
        else
        begin
          Tasks[task_number - 1].Status := 'Не выполнено';
          SaveTasksToFile();
          Writeln('Статус задачи изменён!');
        end;
      end
      else if command = 'delete' then
      begin
        
        for i := task_number - 1 to Length(Tasks) - 2 do
          Tasks[i] := Tasks[i + 1];
        
        SetLength(Tasks, Length(Tasks) - 1);
        SaveTasksToFile();
        Writeln('Задача ', task_number, ' успешно удалена.');
      end;
    end

  
  else if command = 'list' then
    list(false)
  else if command = 'clear' then 
    clear(false)
  else if command = 'stats' then 
    stats(false)
  else if command = 'search' then 
    search(false);
  
     
end;  

      
begin
  
  System.Console.OutputEncoding := System.Text.Encoding.UTF8;
  System.Console.InputEncoding := System.Text.Encoding.UTF8;
  user_input := #0;
  i := 4;
  menu_active := true;
  LoadFile();
  

  if ParamCount > 0 then 
  begin
    CommandLine();
  end  
    
  else
  begin
    Menu(i);
    GotoXY(1, 4);
    while menu_active do 
    begin
      user_input := ReadKey;
    
      if user_input = #40 then
      begin
        if i < 12 then 
        begin
          i := i + 1;
          Menu(i);
          GotoXY(1, i); 
        end     
        else
        begin
         i := 4;
         Menu(i);
         GotoXY(1, i);
        end;
      end;
      
      if user_input = #38 then
      begin
        if i > 4 then 
        begin
          i := i - 1;
          Menu(i);
          GotoXY(1, i); 
        end
        else
        begin
         i := 12;
         Menu(i);
         GotoXY(1, i);
        end;
      end;
         
      if user_input = #13 then
          
        begin
        case i of
          4: add();
          5: list(true);
          6: done(); 
          7 : undone();
          8 : delete_task();
          9 : clear(true);
          10 : stats(true);
          11 : search(true); 
           
        end;
        if i = 12 then 
        begin
          ClrScr();
          menu_active := false;
          Exit;
        end;
  
        
      Menu(i)
      end;
    
      
    end; 
  end;
   
  

end.

