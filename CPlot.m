function varargout = SPlot(varargin)
% SPLOT MATLAB code for SPlot.fig
%      SPLOT, by itself, creates a new SPLOT or raises the existing
%      singleton*.
%
%      H = SPLOT returns the handle to a new SPLOT or the handle to
%      the existing singleton*.
%
%      SPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPLOT.M with the given input arguments.
%
%      SPLOT('Property','Value',...) creates a new SPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SPlot

% Last Modified by GUIDE v2.5 05-Feb-2022 10:08:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @SPlot_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

1
% --- Executes just before SPlot is made visible.
function SPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SPlot (see VARARGIN)

% Choose default command line output for SPlot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

set(handles.botao_Parametros,'Visible','Off');
set(handles.botao_LimitesXeY,'Visible','Off');

painel_LimitesXeY = findobj(0,'type','painel_LimitesXeY'); % algo a ver com esse "parent"
set(painel_LimitesXeY,'parent',handles.painel_LimitesXeY);
handles.painel_LimitesXeY.Position = [2.2 22.076923076923077 64.4 8.153846153846155]; % posição do painel e tamanho
set(painel_LimitesXeY,'Visible','On');

painel_Parametros = findobj(0,'type','painel_Parametros'); % algo a ver com esse "parent"
set(painel_Parametros,'parent',handles.painel_Parametros);
handles.painel_Parametros.Position = [2.2 22.076923076923077 64.4 8.153846153846155]; % posição do painel e tamanho
set(painel_Parametros,'Visible','Off');

global click; % Utilizada para o próprio botão de plot, apagar o plot anterior
click = 1;
global aAntiga; % Utilizada para salvar qual foi o último x' antes do que está digitado atualmente
aAntiga = '';
global bAntiga; % Utilizada para salvar qual foi o último y' antes do que está digitado atualmente
bAntiga = '';
global aAtual; % Salva a equação x' digitada atualmente (antes de clicar para plotar)
aAtual = '';
global bAtual; % Salva a equação y' digitada atualmente (antes de clicar para plotar)
bAtual = '';

global pontox;
pontox = 0;
global pontoy;
pontoy = 1;

global solu;
solu = [];
global m;
m = 1;

global pontosIni;
pontosIni = [];

global pontosIniciais;
pontosIniciais = [];
global h;
h = 1;

global plotPontos;
plotPontos = zeros(1,2);

global xg;
xg = 0;
global yg;
yg = 0;
global tempo;
tempo = 0;

global modo;
modo = 'Padrão';

global dt;
global dtAntigo;
dt = 1e-5; % Tem que converter para número
dtAntigo = dt;

global Tsim;
global TsimAntigo;
Tsim = 10; % Tem que converter para número
TsimAntigo = Tsim;

global Progresso;
global ProgressoAntigo;
Progresso = 'N';
ProgressoAntigo = Progresso;

pos= get(hObject, 'currentpoint'); % Salva a posição atual do cursor
x = pos(1);
y = pos(1,2);
hold all; % Utilizado para conseguir continuar capturando a posição do mouse mesmo depois de fazer o plot
% Esse trecho está aqui junto com a inicialização, pois se deixar apenas no
% evento de ButtonDownFcn, caso plote antes de clicar na área do plot, a
% função para de funcionar.

% Inicia a aplicação já com alguns campos preenchidos

set(handles.valor_EntradaDerivadaX1,'String','10x2'); 
set(handles.valor_EntradaDerivadaY1,'String','0');
set(handles.valor_EntradaDerivadaX2,'String','3x2'); 
set(handles.valor_EntradaDerivadaY2,'String','-x1-x2');
set(handles.valor_EntradaLeiChaveamento,'String','(10x1^2-x2>0)&(x1^2-x2<0)');

set(handles.valor_EntradaXMax,'String','2');
set(handles.valor_EntradaXMin,'String','-2');
set(handles.valor_EntradaYMax,'String','2');
set(handles.valor_EntradaYMin,'String','-2');

set(handles.valor_EntradaC,'String', '20e-6');
set(handles.valor_EntradaL,'String', '10e-3');
set(handles.valor_EntradaR,'String', '100');
set(handles.valor_EntradaVin,'String', '5');

set(handles.valor_EntradaXIni,'String', '0'); % Apresenta o valor da posição de x no campo da condição inicial de x
set(handles.valor_EntradaYIni,'String', '1'); % Apresenta o valor da posição de y no campo da condição inicial de y

global x1SemFormatacao;
global y1SemFormatacao;
global x2SemFormatacao;
global y2SemFormatacao;

x1SemFormatacao = get(handles.valor_EntradaDerivadaX1,'String'); 
y1SemFormatacao = get(handles.valor_EntradaDerivadaY1,'String');
x2SemFormatacao = get(handles.valor_EntradaDerivadaX2,'String'); 
y2SemFormatacao = get(handles.valor_EntradaDerivadaY2,'String');

axes(handles.figura_Graficos);
xlabel('x1');
ylabel('x2');

set(handles.menssagem_Instrucao,'Visible','Off');
set(handles.menssagem_Instrucao,'ForegroundColor','red');

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================


% UIWAIT makes SPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in modos_Operacao.
function modos_Operacao_Callback(hObject, eventdata, handles)
% hObject    handle to modos_Operacao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns modos_Operacao contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modos_Operacao

global x1SemFormatacao;
global y1SemFormatacao;
global x2SemFormatacao;
global y2SemFormatacao;
global modo;

contents = get(handles.modos_Operacao,'String'); 
modo = contents{get(handles.modos_Operacao,'Value')};

if strcmp(modo, 'Buck')
    
    set(handles.valor_EntradaDerivadaX1, 'String', '(1/C)x2 - (1/(R*C))x1');
    set(handles.valor_EntradaDerivadaY1, 'String', '(-1/L)x1 + (1/L)*Vin');
    set(handles.valor_EntradaDerivadaX2, 'String','(1/C)x2 - (1/(R*C)x1)');
    set(handles.valor_EntradaDerivadaY2, 'String','(-1/L)x1');
        
    %limpa_Padrao();
    %limpa_Pontos();
    
    set(handles.botao_Parametros,'Visible','On');
    set(handles.botao_LimitesXeY,'Visible','On');
elseif strcmp(modo, 'Boost')
    set(handles.valor_EntradaDerivadaX1, 'String', '(1/L)*Vin');
    set(handles.valor_EntradaDerivadaY1, 'String', '-(1/R*C)x1');
    set(handles.valor_EntradaDerivadaX2, 'String', '(1/C)x2 - (1/R*C)x1');
    set(handles.valor_EntradaDerivadaY2, 'String', '-(1/L)x1 + (1/L)*Vin');
    
    %limpa_Padrao();
    %limpa_Pontos();
 
    set(handles.botao_Parametros,'Visible','On');
    set(handles.botao_LimitesXeY,'Visible','On');
elseif strcmp(modo, 'Buck-Boost')
    set(handles.valor_EntradaDerivadaX1, 'String', 'Vin');
    set(handles.valor_EntradaDerivadaY1, 'String', '-(1/R*C)x1');
    set(handles.valor_EntradaDerivadaX2, 'String', '(-1/R*C)x1 - (1/C)x2');
    set(handles.valor_EntradaDerivadaY2, 'String', '(1/L)x1');
        
    %limpa_Padrao();
    %limpa_Pontos();
 
    set(handles.botao_Parametros,'Visible','On');
    set(handles.botao_LimitesXeY,'Visible','On');
else
    set(handles.valor_EntradaDerivadaX1, 'String', x1SemFormatacao);
    set(handles.valor_EntradaDerivadaY1, 'String', y1SemFormatacao);
    set(handles.valor_EntradaDerivadaX2, 'String', x2SemFormatacao);
    set(handles.valor_EntradaDerivadaY2, 'String', y2SemFormatacao);
        
    %limpa_Padrao();
    %limpa_Pontos();
    
    set(handles.botao_Parametros,'Visible','Off');
    set(handles.botao_LimitesXeY,'Visible','Off');
    set(handles.painel_Parametros,'Visible','Off');
    set(handles.painel_LimitesXeY,'Visible','On');
end


% --- Executes during object creation, after setting all properties.
function modos_Operacao_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modos_Operacao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaDerivadaX1_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaDerivadaX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaDerivadaX1 as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaDerivadaX1 as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaDerivadaX1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaDerivadaX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaDerivadaY1_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaDerivadaY1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaDerivadaY1 as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaDerivadaY1 as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaDerivadaY1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaDerivadaY1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaDerivadaX2_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaDerivadaX2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaDerivadaX2 as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaDerivadaX2 as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaDerivadaX2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaDerivadaX2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaDerivadaY2_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaDerivadaY2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaDerivadaY2 as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaDerivadaY2 as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaDerivadaY2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaDerivadaY2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaXMax_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaXMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaXMax as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaXMax as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaXMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaXMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaXMin_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaXMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaXMin as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaXMin as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaXMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaXMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaYMax_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaYMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaYMax as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaYMax as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaYMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaYMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaYMin_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaYMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaYMin as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaYMin as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaYMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaYMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function valor_EntradaVin_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaVin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaVin as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaVin as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaVin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaVin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaC_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaC as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaC as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaR_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaR as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaR as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaL_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaL as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaL as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaXIni_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaXIni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaXIni as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaXIni as a double

global pontox;

pontox = get(handles.valor_EntradaXIni, 'String');
pontox = str2double(pontox);

% --- Executes during object creation, after setting all properties.
function valor_EntradaXIni_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaXIni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valor_EntradaYIni_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaYIni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaYIni as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaYIni as a double

global pontoy;

pontoy = get(handles.valor_EntradaYIni, 'String');
pontoy = str2double(pontoy);

% --- Executes during object creation, after setting all properties.
function valor_EntradaYIni_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaYIni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in botao_PlotaEspaco.
function botao_PlotaEspaco_Callback(hObject, eventdata, handles)
% hObject    handle to botao_PlotaEspaco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % =================== INÍCIO ADICIONADO PELO AUTOR ===================
% % ====================================================================

global modoOpera;
modoOpera = 2;
defineModo(handles);
% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --- Executes on button press in botao_Modo1.
function botao_Modo1_Callback(hObject, eventdata, handles)
% hObject    handle to botao_Modo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

global modoOpera;
modoOpera = 1;
defineModo(handles);


% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --- Executes on button press in botao_Modo2.
function botao_Modo2_Callback(hObject, eventdata, handles)
% hObject    handle to botao_Modo2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

global modoOpera;
modoOpera = 0;
defineModo(handles);

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================


% --- Executes on button press in botao_LimitesXeY.
function botao_LimitesXeY_Callback(hObject, eventdata, handles)
% hObject    handle to botao_LimitesXeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

set(handles.painel_Parametros,'Visible','Off');
set(handles.painel_LimitesXeY,'Visible','On');

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================


% --- Executes on button press in botao_Parametros.
function botao_Parametros_Callback(hObject, eventdata, handles)
% hObject    handle to botao_Parametros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

set(handles.painel_Parametros,'Visible','On');
set(handles.painel_LimitesXeY,'Visible','Off');

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================


% --- Executes on button press in botao_Solucao.
function botao_Solucao_Callback(hObject, eventdata, handles)
% hObject    handle to botao_Solucao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

xInicial = get(handles.valor_EntradaXIni, 'string'); %Armazena o valor inicial de X em forma de string
x = str2double(xInicial); % Converte o valor em String para número
yInicial = get(handles.valor_EntradaYIni, 'string'); %Armazena o valor inicial de Y em forma de string
y = str2double(yInicial); % Converte o valor em String para número

%plota_pontoInicial(hObject, handles, x, y);
solucao_Padrao(handles);


% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================


% --- Executes on button press in botao_Limpar.
function botao_Limpar_Callback(hObject, eventdata, handles)
% hObject    handle to botao_Limpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================


limpa_Padrao();
%limpa_Pontos();
% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================


% --------------------------------------------------------------------
function menu_arquivos_Callback(hObject, eventdata, handles)
% hObject    handle to menu_arquivos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_graficos_Callback(hObject, eventdata, handles)
% hObject    handle to menu_graficos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_ajuda_Callback(hObject, eventdata, handles)
% hObject    handle to menu_ajuda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function menu_configuracoes_Callback(hObject, eventdata, handles)
% hObject    handle to menu_configuracoes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global dt;
global Tsim;
global Progresso;

global dtAntigo;
global TsimAntigo;
global ProgressoAntigo;

dtString = num2str(dtAntigo);
TsimString = num2str(TsimAntigo);

prompt = {'Enter com valor para dt:','Entre com valor para Tsim:', 'Deseja ver a progressão do plot? (S/N)'}; % textos das entradas
dlgtitle = 'Configurações'; % título
dims = [1 40]; % tamanho
definput = {dtString, TsimString, ProgressoAntigo}; % dados que quero salvar

global entradasConfig;
entradasConfig = inputdlg(prompt,dlgtitle,dims,definput);

if isempty(entradasConfig)
    dt = dtAntigo;
    Tsim = TsimAntigo;
    Progresso = ProgressoAntigo;
else
    dt = str2double(entradasConfig{1});
    dtAntigo = dt;
    Tsim = str2double(entradasConfig{2});
    TsimAntigo = Tsim;
    Progresso = entradasConfig{3};
    ProgressoAntigo = Progresso;
end

% --- Executes on button press in botao_Fechar.
function botao_Fechar_Callback(hObject, eventdata, handles)
% hObject    handle to botao_Fechar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(painel_Config,'Visible','Off');


% --------------------------------------------------------------------
function submenu_sintaxe_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_sintaxe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

A = ['Constantes:                                                  ';
'   e    base do Logarítmo natural                            ';
'   pi   razão entre circunferência e diâmetro de um circulo  ';
'                                                             ';
'Operadores Aritméticos:                                      ';
'   +    Adição, 5+x                                          ';
'   -    Subtração: 5-x                                       ';
'   *    Multiplicação: 5*x                                   ';
'           também 5x, 5(x), (5)(x),  5sin(x),  5(x+1)        ';
'   /    Divisão: 5/x                                         ';
'   ^    Exponenciação: a^x                                   ';
'                                                             ';
'Funções Trigonométricas (em radianos):                       ';
'   sin(x),  cos(x),  tan(x)                                  ';
'   cot(x),  sec(x),  csc(x)                                  ';
'   asin(x), acos(x), atan(x)                                 ';
'   acot(x), asec(x), acsc(x)                                 ';
'                                                             ';
'Funções Logarítmicas:                                        ';
'   log(x)    logarítmo natural de x                          ';
'   log10(x)  logarítmo de x na base 10                       ';
'                                                             ';
'Funções Hiperbólicas:                                        ';
'   sinh(x),  cosh(x),  tanh(x)                               ';
'   asinh(x), acosh(x), atanh(x)                              ';
'                                                             ';
'Funções Elementares:                                         ';
'   abs(x)    módulo de x                                     ';
'   sqrt(x)   raíz quadrada de x (não definida para x<0)      '];

msgbox(A,'Sintaxe para as equações');


% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --------------------------------------------------------------------
function submenu_sobre_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_sobre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

A = ['Desenvolvido por: Alan Vitor Gomes';
     'Em: 22/02/2022                    ';
     'Plataforma: Matlab R2018a         ';
     'Versão da aplicação: 0.0          ';
];

msgbox(A,'Sobre');


% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --------------------------------------------------------------------
function submenu_xvst_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_xvst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

figure('name',"Gráfico de x1 vs t",'NumberTitle','off');
global xg;
global tempo;
plot(tempo,xg);

%xlim([0 0.03]);

title("Gráfico de x1 vs t");
xlabel('t');
ylabel('x1');

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --------------------------------------------------------------------
function submenu_yvst_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_yvst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

figure('name',"Gráfico de x2 vs t",'NumberTitle','off');
global yg;
global tempo;
plot(tempo,yg);

%xlim([0 0.03]);

title("Gráfico de x2 vs t");
xlabel('t');
ylabel('x2');

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --------------------------------------------------------------------
function submenu_xyvst_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_xyvst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

figure('name',"Gráfico de (x1 e x2) vs t",'NumberTitle','off');
global xg;
global yg;
global tempo;
plot(tempo,xg,tempo,yg);

title("Gráfico de (x1 e x2) vs t");
xlabel('t');
ylabel('x1 e x2');
legend('x1 vs t','x2 vs t');

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --------------------------------------------------------------------
function submenu_3d_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

figure('name',"Gráfico 3D",'NumberTitle','off');
global xg;
global yg;
global tempo;

plot3(xg,yg,tempo);

%zlim([0 0.03]);

grid on;
title("Gráfico 3D de x1, x2 e t");
xlabel('x1');
ylabel('x2');
zlabel('t');
rotate3d on;

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --------------------------------------------------------------------
function submenu_3dcomposto_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_3dcomposto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

% Se o plot da solução escapar dos limites de x ou y, esse plot aqui fica
% estranho.
figure('name',"Gráfico 3D Composto",'NumberTitle','off');
global xg;
global yg;
global tempo;
global yMax;
global xMax;
global yMin;
global xMin;


x0 = zeros(1,length(tempo));
t0 = zeros(1,length(tempo));
for k=1:1:length(tempo)
    x0(k) = xMax;
    t0(k) = 0;
end
plot3(x0,yg,tempo,'r');
hold on

y0 = zeros(1,length(tempo));
for k=1:1:length(tempo)
    y0(k) = yMax;
end
plot3(xg,y0,tempo,'r');

plot3(xg,yg,t0,'r');

plot3(xg,yg,tempo);

%zlim([0 0.03]);

axis([xMin xMax yMin yMax]);

grid on;
title("Gráfico 3D de x1, x2 e t");
xlabel('x1');
ylabel('x2');
zlabel('t');
rotate3d on;
hold off;

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --------------------------------------------------------------------
function submenu_chaveamento_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_chaveamento (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

figure('name',"Gráfico de Chave vs t",'NumberTitle','off');
global chave;
global tempo;
stairs(tempo,chave);
ylim([0 1.1]);

%xlim([0 0.03]);

title("Gráfico de Chave vs t");
xlabel('t');
ylabel('Chave');

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --------------------------------------------------------------------
function submenu_salvardados_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_salvardados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function submenu_abrir_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_abrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function submenu_salavarimagem_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_salavarimagem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

[file, path] = uiputfile('*.png');
FileAddress = [path,'\',file];
% FileAddress = sprintf('%s','\','%s',path,file);
saveas(gcf,FileAddress,'png');

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% --- Executes on mouse press over axes background.
function figura_Graficos_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figura_Graficos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


pos = get(hObject, 'currentpoint'); % Armazena a posição do cursor
x = pos(1); % Salva a posição de x na variável x
y = pos(1,2); % Salva a posição de y na variável y

%hold all; % Utilizado para poder continuar salvando a posição do cursor mesmo após plotar algo no gráfico

plota_pontoInicial(hObject, handles, x, y);


function valor_EntradaLeiChaveamento_Callback(hObject, eventdata, handles)
% hObject    handle to valor_EntradaLeiChaveamento (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valor_EntradaLeiChaveamento as text
%        str2double(get(hObject,'String')) returns contents of valor_EntradaLeiChaveamento as a double


% --- Executes during object creation, after setting all properties.
function valor_EntradaLeiChaveamento_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valor_EntradaLeiChaveamento (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ====================================================================
% ====================== INÍCIO FUNÇÕES CRIADAS ======================
% ====================================================================

function [] = defineModo(handles)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

% =============== variáveis para manipular o gráfico =================
    limpa_Pontos();
%     global pontosIniciais;
%     delete(pontosIniciais);
%     pontosIniciais = [];

    global espacoVetorial; % Utilizada para salvar o plot do espaço vetorial.
    delete(espacoVetorial); % Apaga o espaço vetorial que estava plotado
    espacoVetorial = [];

    limpa_Padrao();
%     global solu; % Utilizada para salvar o plot do espaço vetorial.
%     delete(solu); % Apaga o espaço vetorial que estava plotado
%     solu = [];
    
    global X1;
    global Y1;
    global X2;
    global Y2;

    global x1SemFormatacao;
    global y1SemFormatacao;
    global x2SemFormatacao;
    global y2SemFormatacao;

    global LeiDig;
    global LeiDigSemFormatacao;

    global modo;

    %=====================================================================

    % =================== Equações do Usuário ============================

    if strcmp(modo, 'Padrão')
        x1SemFormatacao = get(handles.valor_EntradaDerivadaX1, 'string'); %Armazena a equação X' em forma de String e sem alteração para ficar salvo quando volta para esse modo
        y1SemFormatacao = get(handles.valor_EntradaDerivadaY1, 'string');
        x2SemFormatacao = get(handles.valor_EntradaDerivadaX2, 'string');
        y2SemFormatacao = get(handles.valor_EntradaDerivadaY2, 'string');
    end

    X1 = get(handles.valor_EntradaDerivadaX1, 'string'); %Armazena a equação X' em forma de String e sem alteração para ficar salvo quando volta para esse modo
    X1 = substitui(X1, 'x');
    X1 = substitui(X1, 'y');
    X1 = substituiexp(X1);
    X1 = substituinumeroparenteses(X1);

    Y1 = get(handles.valor_EntradaDerivadaY1, 'string'); %Armazena a equação Y' em forma de String e sem alteração para ficar salvo quando volta para esse modo
    Y1 = substitui(Y1, 'x');
    Y1 = substitui(Y1, 'y');
    Y1 = substituiexp(Y1);
    Y1 = substituinumeroparenteses(Y1);

    X2 = get(handles.valor_EntradaDerivadaX2, 'string'); %Armazena a equação X' em forma de String e sem alteração para ficar salvo quando volta para esse modo
    X2 = substitui(X2, 'x');
    X2 = substitui(X2, 'y');
    X2 = substituiexp(X2);
    X2 = substituinumeroparenteses(X2);

    Y2 = get(handles.valor_EntradaDerivadaY2, 'string'); %Armazena a equação Y' em forma de String e sem alteração para ficar salvo quando volta para esse modo
    Y2 = substitui(Y2, 'x');
    Y2 = substitui(Y2, 'y');
    Y2 = substituiexp(Y2);
    Y2 = substituinumeroparenteses(Y2);

    LeiDig = get(handles.valor_EntradaLeiChaveamento, 'string'); %Armazena a equação Y' em forma de String
    LeiDigSemFormatacao = get(handles.valor_EntradaLeiChaveamento, 'string'); %Armazena a equação Y' em forma de String e sem alteração para ficar salvo quando volta para esse modo

    LeiDig = substitui(LeiDig, 'x');
    LeiDig = substitui(LeiDig, 'y');
    LeiDig = substituiexp(LeiDig);
    LeiDig = substituinumeroparenteses(LeiDig);

    plota_EspacoPadrao(handles);
  
% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================


% Função para acusar erro de sintaxe, no caso de o usuário não ter fechado
% todos os parênteses abertos
function [saida] = errosintaxe(entradausu)

abriu = find(entradausu == '(');
if(isempty(abriu))
    abriu = [];
end
vezesabriu = length(abriu);

fechou = find(entradausu == ')');
if(isempty(fechou))
    fechou = [];
end
vezesfechou = length(fechou);

if vezesabriu ~= vezesfechou
    saida = 1;
else
    saida = 0;
end

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% Função para dicionar corrigir a escrita de expoente de maneira que
% funcione, caso o usuário digite sem o ponto.
function [saida] = substituiexp(funcao)
saida = strrep(funcao,'^','.^');

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% Função para dicionar o símbolo de multiplicação (*) na equação, caso o
% usuário digite sem o mesmo.
function [saida] = substituinumeroparenteses(entradausu)
a = find(entradausu == '(');

if ismember(1,a)
    a=a(a~=1);
end
for v=a
    if isstrprop(entradausu(v-1),'digit')
        entrada = [entradausu(1:(v-1)),'.*',entradausu((v):length(entradausu))];
        entradausu = entrada;
    end
end
saida = entradausu;

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% Função para dicionar o símbolo de multiplicação (*) na equação, caso o
% usuário digite sem o mesmo.
function [saida] = substitui(entradausu, variavel)

entradausu = [' ',entradausu,' '];
a = find(entradausu == variavel);
b = flip(a);

for v = b
    if strcmp (entradausu(v-1), '+') || strcmp (entradausu(v-1), '-') || strcmp (entradausu(v-1), '/') || strcmp (entradausu(v-1), '^') || strcmp (entradausu(v-1), ' ') || strcmp (entradausu(v-1), '(')
        if strcmp (entradausu(v+1), '(') || strcmp (entradausu(v+1), 's') || strcmp (entradausu(v+1), 'c') || strcmp (entradausu(v+1), 't') || strcmp (entradausu(v+1), 'a')
            entrada = [entradausu(1:(v)),'.*',entradausu((v+1):length(entradausu))];
            entradausu = entrada;
        else
            entrada = [entradausu(1:(v-1)),'1.*',entradausu((v):length(entradausu))];
            entradausu = entrada;
        end
    elseif strcmp (entradausu(v+1), '(')
        entrada = [entradausu(1:(v)),'.*',entradausu((v+1):length(entradausu))];
        entradausu = entrada;
        entradausu = [entradausu(1:(v-1)),'.*',entradausu(v:length(entradausu))];
    else
        entrada = [entradausu(1:(v-1)),'.*',entradausu(v:length(entradausu))];
        entradausu = entrada;
    end
end
saida = entradausu(2:(length(entradausu)-1));

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% Função para apagar as soluções presentes no gráfico.
function [] = apagatudo(solucao)

%!!! As vezes essa função da erro e é necessário declarar as variáveis
%globais !!!

%global solu;
%delete(solu); % Limpando o vetor com os plots das soluções
delete(solucao); % Limpando o vetor com os plots das soluções

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



function [] = plota_pontoInicial(hObject, handles, x, y)
% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

set(handles.valor_EntradaXIni,'String',num2str(x)); % Apresenta o valor da posição de x no campo da condição inicial de x
set(handles.valor_EntradaYIni,'String',num2str(y)); % Apresenta o valor da posição de y no campo da condição inicial de y

global pontosIniciais;
global pontox;
global pontoy;

pontox = x;
pontoy = y;

delete(pontosIniciais);
pontosIniciais = plot (pontox, pontoy, 'ro');

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% Adaptado do método feito pelo Henrique
function [] = plota_EspacoPadrao(handles)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================
global modoOpera;
global espacoVetorial;

global X1; 
global Y1;
global X2;
global Y2;
global LeiDig;

global xMax;
global xMin;
global yMax;
global yMin;

global C;
global L;
global R;
global Vin;

C = get(handles.valor_EntradaC, 'String');
C = str2double(C);
L = get(handles.valor_EntradaL,'String');
L = str2double(L);
R = get(handles.valor_EntradaR, 'String');
R = str2double(R);
Vin = get(handles.valor_EntradaVin, 'String');
Vin = str2double(Vin);


% =================== Erro Digitação =================================

set(handles.menssagem_Instrucao,'Visible','Off');
set(handles.menssagem_Instrucao,'String',' ')
set(handles.valor_EntradaDerivadaX1,'ForegroundColor','black');
set(handles.valor_EntradaDerivadaY1,'ForegroundColor','black');
set(handles.valor_EntradaDerivadaX2,'ForegroundColor','black');
set(handles.valor_EntradaDerivadaY2,'ForegroundColor','black');
set(handles.valor_EntradaLeiChaveamento,'ForegroundColor','black');

if errosintaxe(X1) == 1
    set(handles.menssagem_Instrucao,'Visible','On');
    set(handles.menssagem_Instrucao,'String',"erro de sintaxe em x1' ou x2'");
    set(handles.valor_EntradaDerivadaX1,'ForegroundColor','red');
end
if errosintaxe(Y1) == 1
    set(handles.menssagem_Instrucao,'Visible','On');
    set(handles.menssagem_Instrucao,'String',"erro de sintaxe em x1' ou x2'")
    set(handles.valor_EntradaDerivadaY1,'ForegroundColor','red');
end
if errosintaxe(X2) == 1
    set(handles.menssagem_Instrucao,'Visible','On');
    set(handles.menssagem_Instrucao,'String',"erro de sintaxe em x1'' ou x2''");
    set(handles.valor_EntradaDerivadaX2,'ForegroundColor','red');
end
if errosintaxe(Y2) == 1
    set(handles.menssagem_Instrucao,'Visible','On');
    set(handles.menssagem_Instrucao,'String',"erro de sintaxe em x1'' ou x2''")
    set(handles.valor_EntradaDerivadaY2,'ForegroundColor','red');
end

if errosintaxe(LeiDig) == 1
    set(handles.menssagem_Instrucao,'Visible','On');
    set(handles.menssagem_Instrucao,'String',"erro de sintaxe na Lei")
    set(handles.valor_EntradaLeiChaveamento,'ForegroundColor','red');
end

%=======================================================================

xMaximo = get(handles.valor_EntradaXMax, 'string'); %Armazena o limite máximo de X em forma de string
xMax = str2double(xMaximo); % Converte o valor em String para número
xMinimo = get(handles.valor_EntradaXMin, 'string'); %Armazena o limite minimo de X em forma de string
xMin = str2double(xMinimo); % Converte o valor em String para número
yMaximo = get(handles.valor_EntradaYMax, 'string'); %Armazena o limite máximo de Y em forma de string
yMax = str2double(yMaximo); % Converte o valor em String para número
yMinimo = get(handles.valor_EntradaYMin, 'string'); %Armazena o limite minimo de Y em forma de string
yMin = str2double(yMinimo); % Converte o valor em String para número

Divisoes=20; %Variável para ajustar quantas divisoes dentro do quiver 
             %(ou seja, quantas flechas) deveria poder ser escolhida pelo usuario    

Divx=(xMax-xMin)/Divisoes;   
Divy=(yMax-yMin)/Divisoes;

[x,y] = meshgrid(xMin:Divx:xMax, yMin:Divy:yMax); % Cria um vetor para X e Y

global a1Antiga;
global b1Antiga;
global a2Antiga;
global b2Antiga;

global u1;
global u2;
global v1;
global v2;
global Lei;

a1Antiga = X1;
b1Antiga = Y1;
a2Antiga = X2;
b2Antiga = Y2;

u1 = str2func(['@(x1, x2, R, C, L, Vin)', a1Antiga]); %Converte a equação X' em forma de String para Função
v1 = str2func(['@(x1, x2, R, C, L, Vin)', b1Antiga]); %Converte a equação Y' em forma de String para Função
u2 = str2func(['@(x1, x2, R, C, L, Vin)', a2Antiga]); %Converte a equação X' em forma de String para Função
v2 = str2func(['@(x1, x2, R, C, L, Vin)', b2Antiga]); %Converte a equação Y' em forma de String para Função
Lei = str2func(['@(x1, x2)', LeiDig]);
    
if modoOpera == 1
    for(i=[1:1:Divisoes+1])
        for(j=[1:1:Divisoes+1])
            funu(i,j) = u1(x(i,j),y(i,j), R, C, L, Vin); 
            funv(i,j) = v1(x(i,j),y(i,j), R, C, L, Vin);
        end
    end
elseif modoOpera == 0
    for(i=[1:1:Divisoes+1])
        for(j=[1:1:Divisoes+1])
            funu(i,j) = u2(x(i,j),y(i,j), R, C, L, Vin); 
            funv(i,j) = v2(x(i,j),y(i,j), R, C, L, Vin);                   
        end
    end
else 
    for(i=[1:1:Divisoes+1])
        for(j=[1:1:Divisoes+1])
            if (Lei(x(i,j), y(i,j))==1), %% Caso satifaça a lei de chaveamento será utilizada a dinâmica do modo 1        
                     funu(i,j) = u1(x(i,j),y(i,j), R, C, L, Vin); 
                     funv(i,j) = v1(x(i,j),y(i,j), R, C, L, Vin);
                    
            else                    %% Caso não satisfaça é utilizada a dinâmica 
                     funu(i,j) = u2(x(i,j),y(i,j), R, C, L, Vin); 
                     funv(i,j) = v2(x(i,j),y(i,j), R, C, L, Vin);                   
            end
        end
    end    
end
    % ================= plot do espaço vetorial ========================    
Len = sqrt(funu.^2+funv.^2);
espacoVetorial = quiver(x, y, funu./Len, funv./Len, .3, 'Color', [200 200 200]/255);

% espacoVetorial.ShowArrowHead = 'off';
espacoVetorial.MaxHeadSize = 0.2;

axis([xMin xMax yMin yMax]);
hold on

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================


% Adaptado do método feito pelo Henrique
function [] = solucao_Padrao(handles)

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

global pontox;
global pontoy;
global modoOpera;
global pontosIni;
global dt;
global Tsim;
global solu;
global m;
global xg;
global yg;
global tempo;
global xMax; % Utiliza o X máximo que foi usado para fazer o espaço vetorial atual
global xMin; % Utiliza o X mínimo que foi usado para fazer o espaço vetorial atual
global yMax; % Utiliza o Y máximo que foi usado para fazer o espaço vetorial atual
global yMin; % Utiliza o Y mínimo que foi usado para fazer o espaço vetorial atual

global u1;
global u2;
global v1;
global v2;
global Lei;
global C;
global R;
global L;
global Vin;

xInicial = get(handles.valor_EntradaXIni, 'string'); %Armazena o valor inicial de X em forma de string
XIni = str2double(xInicial); % Converte o valor em String para número
yInicial = get(handles.valor_EntradaYIni, 'string'); %Armazena o valor inicial de Y em forma de string
YIni = str2double(yInicial); % Converte o valor em String para número

k = 1;
xg(k) = XIni; % Armazena a condição inicial de X na primeira posição de um vetor
yg(k) = YIni; % Armazena a condição inicial de Y na primeira posição de um vetor
%dt = 1e-5;
%Tsim = 10;
global chave;

if modoOpera == 1
    for t=0:dt:Tsim  
        k = k+1;  
        XIni = XIni+u1(XIni, YIni, R, C, L, Vin)*dt;
        YIni = YIni+v1(XIni, YIni, R, C, L, Vin)*dt;
        sigma(k) = 1;       %% Modo ativo neste tempo =1;        
        tempo(k) = t; 
        xg(k) = XIni;
        yg(k) = YIni; 
    end
elseif modoOpera == 0
    for t=0:dt:Tsim  
        k = k+1;
        % Caso não satisfaça é utilizada a dinâmica 2
        XIni = XIni+u2(XIni, YIni, R, C, L, Vin)*dt;
        YIni = YIni+v2(XIni, YIni, R, C, L, Vin)*dt;
        sigma(k) = 2;       %% Modo ativo neste tempo =2;
        tempo(k) = t;
        xg(k) = XIni;
        yg(k) = YIni; 
    end    
else 
    for t=0:dt:Tsim  
    k = k+1;
        
    if (Lei(XIni, YIni)==1), %% Caso satifaça a lei de chaveamento será utilizada a dinâmica do modo 1
        XIni = XIni+u1(XIni, YIni, R, C, L, Vin)*dt;
        YIni = YIni+v1(XIni, YIni, R, C, L, Vin)*dt;
        sigma(k) = 1;       %% Modo ativo neste tempo =1;
        chave(k) = 1;
    else                    %% Caso não satisfaça é utilizada a dinâmica 2
        XIni = XIni+u2(XIni, YIni, R, C, L, Vin)*dt;
        YIni = YIni+v2(XIni, YIni, R, C, L, Vin)*dt;
        sigma(k) = 2;       %% Modo ativo neste tempo =2;
        chave(k) = 0;
    end
        tempo(k) = t; 
        xg(k) = XIni;
        yg(k) = YIni; 
    end
end

% delete(Curva_Online);
% Curva_Online = plot(xg(1:k),yg(1:k),'r');

% Curva_Online = animatedline;

axes(handles.figura_Graficos);
pontosIni(m) = plot (pontox, pontoy, 'ro');
solu(m) = plot(xg,yg,'r'); % Salva o plot atual em um vetor
axis([xMin xMax yMin yMax]); % Limites iguais ao plot do espaço vetorial

% for j=1:1:length(xg)
%     addpoints(Curva_Online, xg(j), yg(j));
%     drawnow
% end

m = m+1;

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================


function [] = limpa_Padrao()

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

global solu;
global pontosIni;
global m;
m = 1;
apagatudo(solu); % Função para deletar o vetor com os plots das soluções e assim apaga-las do plot
solu = []; % recria o vetor de soluções para não dar erro de vetor inexistente
apagatudo(pontosIni);
pontosIni = [];

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



function [] = limpa_Pontos()

% =================== INÍCIO ADICIONADO PELO AUTOR ===================
% ====================================================================

global pontosIniciais;
global h;
h = 1;
delete(pontosIniciais);
pontosIniciais = [];

% ===================== FIM ADICIONADO PELO AUTOR ====================
% ====================================================================



% ====================================================================
% ======================= FIM FUNÇÕES CRIADAS ========================
% ====================================================================
