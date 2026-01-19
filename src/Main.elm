module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Time


-- MODEL

type alias Todo =
    { id : Int
    , text : String
    , completed : Bool
    }


type alias Model =
    { counter : Int
    , isAnimating : Bool
    , userName : String
    , email : String
    , formErrors : List String
    , isFormSubmitted : Bool
    , todos : List Todo
    , todoInput : String
    , nextId : Int
    , currentTime : Int
    , timerRunning : Bool
    , selectedColor : String
    , colorPreview : String
    , toggleState : Bool
    , accordionOpen : Bool
    , progressValue : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { counter = 0
      , isAnimating = False
      , userName = ""
      , email = ""
      , formErrors = []
      , isFormSubmitted = False
      , todos = []
      , todoInput = ""
      , nextId = 1
      , currentTime = 0
      , timerRunning = False
      , selectedColor = "#667eea"
      , colorPreview = "#667eea"
      , toggleState = False
      , accordionOpen = False
      , progressValue = 0
      }
    , Cmd.none
    )


-- UPDATE

type Msg
    = Increment
    | Decrement
    | Reset
    | TriggerAnimation
    | UpdateUserName String
    | UpdateEmail String
    | ValidateForm
    | ResetForm
    | UpdateTodoInput String
    | AddTodo
    | ToggleTodo Int
    | DeleteTodo Int
    | ClearCompleted
    | Tick Time.Posix
    | ToggleTimer
    | ResetTimer
    | UpdateColor String
    | ApplyColor
    | ToggleSwitch
    | ToggleAccordion
    | UpdateProgress String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model 
                | counter = model.counter + 1
                , isAnimating = True 
              }
            , Cmd.none
            )

        Decrement ->
            ( { model 
                | counter = model.counter - 1
                , isAnimating = True 
              }
            , Cmd.none
            )

        Reset ->
            ( { model 
                | counter = 0
                , isAnimating = False 
              }
            , Cmd.none
            )

        TriggerAnimation ->
            ( { model | isAnimating = not model.isAnimating }
            , Cmd.none
            )

        UpdateUserName name ->
            ( { model | userName = name, isFormSubmitted = False }
            , Cmd.none
            )

        UpdateEmail email ->
            ( { model | email = email, isFormSubmitted = False }
            , Cmd.none
            )

        ValidateForm ->
            let
                errors =
                    validateFormData model.userName model.email
            in
            ( { model 
                | formErrors = errors
                , isFormSubmitted = List.isEmpty errors
              }
            , Cmd.none
            )

        ResetForm ->
            ( { model 
                | userName = ""
                , email = ""
                , formErrors = []
                , isFormSubmitted = False
              }
            , Cmd.none
            )

        UpdateTodoInput input ->
            ( { model | todoInput = input }
            , Cmd.none
            )

        AddTodo ->
            if String.trim model.todoInput == "" then
                ( model, Cmd.none )

            else
                let
                    newTodo =
                        { id = model.nextId
                        , text = model.todoInput
                        , completed = False
                        }
                in
                ( { model 
                    | todos = model.todos ++ [ newTodo ]
                    , todoInput = ""
                    , nextId = model.nextId + 1
                  }
                , Cmd.none
                )

        ToggleTodo id ->
            ( { model 
                | todos = List.map (toggleTodoHelper id) model.todos
              }
            , Cmd.none
            )

        DeleteTodo id ->
            ( { model 
                | todos = List.filter (\t -> t.id /= id) model.todos
              }
            , Cmd.none
            )

        ClearCompleted ->
            ( { model 
                | todos = List.filter (\t -> not t.completed) model.todos
              }
            , Cmd.none
            )

        Tick _ ->
            ( { model 
                | currentTime = 
                    if model.timerRunning then
                        model.currentTime + 1
                    else
                        model.currentTime
              }
            , Cmd.none
            )

        ToggleTimer ->
            ( { model | timerRunning = not model.timerRunning }
            , Cmd.none
            )

        ResetTimer ->
            ( { model | currentTime = 0, timerRunning = False }
            , Cmd.none
            )

        UpdateColor color ->
            ( { model | colorPreview = color }
            , Cmd.none
            )

        ApplyColor ->
            ( { model | selectedColor = model.colorPreview }
            , Cmd.none
            )

        ToggleSwitch ->
            ( { model | toggleState = not model.toggleState }
            , Cmd.none
            )

        ToggleAccordion ->
            ( { model | accordionOpen = not model.accordionOpen }
            , Cmd.none
            )

        UpdateProgress value ->
            ( { model 
                | progressValue = Maybe.withDefault 0 (String.toInt value)
              }
            , Cmd.none
            )


-- HELPER FUNCTIONS

toggleTodoHelper : Int -> Todo -> Todo
toggleTodoHelper id todo =
    if todo.id == id then
        { todo | completed = not todo.completed }

    else
        todo


validateFormData : String -> String -> List String
validateFormData name email =
    let
        nameError =
            if String.length name < 3 then
                Just "Nama harus minimal 3 karakter"

            else
                Nothing

        emailError =
            if not (String.contains "@" email) || not (String.contains "." email) then
                Just "Email harus valid (mengandung @ dan .)"

            else
                Nothing
    in
    List.filterMap identity [ nameError, emailError ]


formatTime : Int -> String
formatTime seconds =
    let
        mins =
            String.fromInt (seconds // 60)

        secs =
            String.fromInt (modBy 60 seconds)

        paddedSecs =
            if modBy 60 seconds < 10 then
                "0" ++ secs

            else
                secs
    in
    mins ++ ":" ++ paddedSecs


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ viewHeader
        , viewCounter model
        , viewForm model
        , viewTodoList model
        , viewTimer model
        , viewColorPicker model
        , viewToggleSwitch model
        , viewAccordion model
        , viewProgressBar model
        , viewFooter
        ]


viewHeader : Html Msg
viewHeader =
    header [ class "header" ]
        [ h1 [] [ text "🎯 Elm Interactive UI" ]
        , p [ class "subtitle" ] 
            [ text "Functional Frontend Development - No Runtime Errors" ]
        , p [ class "badge" ] [ text "9 Interactive Components" ]
        ]


viewCounter : Model -> Html Msg
viewCounter model =
    section [ class "counter-section" ]
        [ h2 [] [ text "🔢 Counter + Animation" ]
        , div 
            [ class "counter-display"
            , classList [ ( "animating", model.isAnimating ) ]
            ] 
            [ text (String.fromInt model.counter) ]
        , div [ class "counter-controls" ]
            [ button [ onClick Decrement, class "btn btn-secondary" ] [ text "➖" ]
            , button [ onClick Reset, class "btn btn-danger" ] [ text "🔄" ]
            , button [ onClick Increment, class "btn btn-primary" ] [ text "➕" ]
            ]
        ]


viewForm : Model -> Html Msg
viewForm model =
    section [ class "form-section" ]
        [ h2 [] [ text "📝 Form dengan Validasi" ]
        , div [ class "form-group" ]
            [ label [] [ text "Nama Lengkap" ]
            , input 
                [ type_ "text"
                , placeholder "Minimal 3 karakter"
                , value model.userName
                , onInput UpdateUserName
                , class "form-input"
                ] []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Email" ]
            , input 
                [ type_ "email"
                , placeholder "contoh@email.com"
                , value model.email
                , onInput UpdateEmail
                , class "form-input"
                ] []
            ]
        , viewFormErrors model.formErrors
        , viewFormSuccess model.isFormSubmitted
        , div [ class "form-actions" ]
            [ button [ onClick ValidateForm, class "btn btn-primary" ] [ text "✓ Validate" ]
            , button [ onClick ResetForm, class "btn btn-secondary" ] [ text "↻ Reset" ]
            ]
        ]


viewFormErrors : List String -> Html Msg
viewFormErrors errors =
    if List.isEmpty errors then
        text ""

    else
        div [ class "errors" ]
            (List.map (\error -> p [ class "error-message" ] [ text ("❌ " ++ error) ]) errors)


viewFormSuccess : Bool -> Html Msg
viewFormSuccess isSubmitted =
    if isSubmitted then
        div [ class "success" ]
            [ p [ class "success-message" ] [ text "✅ Form valid! Data siap diproses." ] ]

    else
        text ""


viewTodoList : Model -> Html Msg
viewTodoList model =
    section [ class "todo-section" ]
        [ h2 [] [ text "✅ Todo List (Immutable)" ]
        , div [ class "todo-input-group" ]
            [ input 
                [ type_ "text"
                , placeholder "Tambah todo..."
                , value model.todoInput
                , onInput UpdateTodoInput
                , class "form-input"
                ] []
            , button [ onClick AddTodo, class "btn btn-primary" ] [ text "+" ]
            ]
        , div [ class "todo-list" ]
            (List.map viewTodoItem model.todos)
        , if List.isEmpty model.todos then
            p [ class "hint" ] [ text "Belum ada todo. Mulai dengan menambahkan satu!" ]

          else
            div [ class "todo-stats" ]
                [ p [] 
                    [ text ("Total: " ++ String.fromInt (List.length model.todos))
                    , text " | "
                    , text ("Selesai: " ++ String.fromInt (countCompleted model.todos))
                    ]
                , button [ onClick ClearCompleted, class "btn btn-danger btn-sm" ] 
                    [ text "🗑️ Hapus Selesai" ]
                ]
        ]


viewTodoItem : Todo -> Html Msg
viewTodoItem todo =
    div [ class "todo-item", classList [ ( "completed", todo.completed ) ] ]
        [ input 
            [ type_ "checkbox"
            , checked todo.completed
            , onClick (ToggleTodo todo.id)
            ] []
        , span [ class "todo-text" ] [ text todo.text ]
        , button 
            [ onClick (DeleteTodo todo.id)
            , class "btn-delete"
            ] 
            [ text "×" ]
        ]


countCompleted : List Todo -> Int
countCompleted todos =
    List.filter .completed todos |> List.length


viewTimer : Model -> Html Msg
viewTimer model =
    section [ class "timer-section" ]
        [ h2 [] [ text "⏱️ Timer (Pure Side Effects)" ]
        , div [ class "timer-display" ]
            [ text (formatTime model.currentTime) ]
        , div [ class "timer-controls" ]
            [ button 
                [ onClick ToggleTimer
                , class "btn"
                , classList 
                    [ ( "btn-success", not model.timerRunning )
                    , ( "btn-warning", model.timerRunning )
                    ]
                ] 
                [ text (if model.timerRunning then "⏸️ Pause" else "▶️ Start") ]
            , button [ onClick ResetTimer, class "btn btn-danger" ] [ text "🔄 Reset" ]
            ]
        ]


viewColorPicker : Model -> Html Msg
viewColorPicker model =
    section [ class "color-section" ]
        [ h2 [] [ text "🎨 Color Picker (State Preview)" ]
        , div [ class "color-picker-container" ]
            [ div 
                [ class "color-preview"
                , style "background-color" model.colorPreview
                ] []
            , input 
                [ type_ "color"
                , value model.colorPreview
                , onInput UpdateColor
                , class "color-input"
                ] []
            , button [ onClick ApplyColor, class "btn btn-primary" ] 
                [ text "Apply Color" ]
            ]
        , p [ class "hint" ] 
            [ text ("Selected: " ++ model.selectedColor) ]
        ]


viewToggleSwitch : Model -> Html Msg
viewToggleSwitch model =
    section [ class "toggle-section" ]
        [ h2 [] [ text "🔘 Toggle Switch (Binary State)" ]
        , div [ class "toggle-container" ]
            [ div 
                [ class "toggle-switch"
                , classList [ ( "active", model.toggleState ) ]
                , onClick ToggleSwitch
                ]
                [ div [ class "toggle-slider" ] [] ]
            , span [ class "toggle-label" ] 
                [ text (if model.toggleState then "ON ✓" else "OFF ✗") ]
            ]
        ]


viewAccordion : Model -> Html Msg
viewAccordion model =
    section [ class "accordion-section" ]
        [ h2 [] [ text "📂 Accordion (Conditional Rendering)" ]
        , div [ class "accordion" ]
            [ div 
                [ class "accordion-header"
                , onClick ToggleAccordion
                ]
                [ text "Click to expand/collapse"
                , span [ class "accordion-icon" ] 
                    [ text (if model.accordionOpen then "▼" else "▶") ]
                ]
            , if model.accordionOpen then
                div [ class "accordion-content" ]
                    [ p [] [ text "Ini adalah konten accordion!" ]
                    , p [] [ text "Di Elm, conditional rendering sangat type-safe." ]
                    , p [] [ text "Tidak ada kemungkinan render null/undefined." ]
                    ]

              else
                text ""
            ]
        ]


viewProgressBar : Model -> Html Msg
viewProgressBar model =
    section [ class "progress-section" ]
        [ h2 [] [ text "📊 Progress Bar (Range Input)" ]
        , div [ class "progress-container" ]
            [ input 
                [ type_ "range"
                , Html.Attributes.min "0"
                , Html.Attributes.max "100"
                , value (String.fromInt model.progressValue)
                , onInput UpdateProgress
                , class "progress-input"
                ] []
            , div [ class "progress-bar-wrapper" ]
                [ div 
                    [ class "progress-bar"
                    , style "width" (String.fromInt model.progressValue ++ "%")
                    ] []
                ]
            , p [ class "progress-text" ] 
                [ text (String.fromInt model.progressValue ++ "%") ]
            ]
        ]


viewFooter : Html Msg
viewFooter =
    footer [ class "footer" ]
        [ p [] 
            [ strong [] [ text "Elm Architecture (MVU):" ]
            , text " View → Msg → Update → Model → View (loop)"
            ]
        , p [] 
            [ text "9 komponen interaktif, 100% type-safe, zero runtime errors." ]
        ]


-- MAIN

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }