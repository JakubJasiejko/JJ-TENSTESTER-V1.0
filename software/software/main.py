import tkinter as tk  # Importuje moduł tkinter i przypisuje mu alias tk

import serial  # Importuje moduł serial, używany do komunikacji szeregowej

def connect_to_arduino():
    # Definiuje funkcję connect_to_arduino(), wywoływaną po naciśnięciu przycisku "Confirm"
    com_port = com_port_entry.get()
    # Pobiera wartość wpisaną w polu tekstowym i przypisuje ją do zmiennej com_port

    try:
        arduino = serial.Serial(com_port, baudrate=9600, timeout=1)
        # Tworzy obiekt Serial reprezentujący połączenie szeregowe z Arduino
        # com_port to numer portu COM, baudrate=9600 określa szybkość transmisji, timeout=1 ustawia maksymalny czas oczekiwania na odczyt
        print(f"Connected to Arduino on {com_port}")
        # Wyświetla komunikat o pomyślnym połączeniu z Arduino na określonym porcie COM
        # Tutaj można dodać kod do obsługi połączenia z Arduino
    except serial.SerialException as e:
        # Obsługuje wyjątek w przypadku błędu połączenia z Arduino
        print(f"Error: {e}")
        # Wyświetla komunikat o błędzie w konsoli
        # Tutaj można obsłużyć błąd połączenia z Arduino

# Tworzy główne okno aplikacji
root = tk.Tk()

# Ustawia tytuł głównego okna
root.title("Arduino Connection")

# Tworzy etykietę informacyjną
com_port_label = tk.Label(root, text="Enter COM Port:")

# Umieszcza etykietę w oknie
com_port_label.pack()

# Tworzy pole tekstowe
com_port_entry = tk.Entry(root)

# Umieszcza pole tekstowe w oknie
com_port_entry.pack()

# Tworzy przycisk "Confirm", który po naciśnięciu wywoła funkcję connect_to_arduino()
confirm_button = tk.Button(root, text="Confirm", command=connect_to_arduino)

# Umieszcza przycisk w oknie
confirm_button.pack()

def execute_test():
    # Funkcja wywoływana po naciśnięciu przycisku "Execute Test"
    first_side_length_value = float(first_side_length_entry.get())
    second_side_length_value = float(second_side_length_entry.get())
    initial_length_value = float(initial_length_entry.get())
    velocity_value = float(velocity_entry.get())
    test_length_value = float(test_length_entry.get())

    # Tutaj możesz dodać kod do wykonania testu z wprowadzonymi danymi
    print("Test executed with values:")
    print(f"First Side Length: {first_side_length_value}")
    print(f"Second Side Length: {second_side_length_value}")
    print(f"Initial Length: {initial_length_value}")
    print(f"Velocity: {velocity_value}")
    print(f"Test Length: {test_length_value}")

def move_upwards():
    # Funkcja wywoływana po naciśnięciu przycisku "Move Upwards"
# Tutaj możesz dodać kod do ruchu w górę

def move_downwards():
# Funkcja wywoływana po naciśnięciu przycisku "Move Downwards"
    # Tutaj możesz dodać kod do ruchu w dół

def set_values():
    # Funkcja wywoływana po naciśnięciu przycisku "Set Values"
    # Resetuje wartości pól tekstowych
    first_side_length_entry.delete(0, tk.END)
    second_side_length_entry.delete(0, tk.END)
    initial_length_entry.delete(0, tk.END)
    velocity_entry.delete(0, tk.END)
    test_length_entry.delete(0, tk.END)

# Tworzy główne okno aplikacji
root = tk.Tk()
root.title("Test Window")

# Tworzy etykiety i pola tekstowe
first_side_length_label = tk.Label(root, text="First Side Length:")
first_side_length_label.grid(row=0, column=0)
first_side_length_entry = tk.Entry(root)
first_side_length_entry.grid(row=0, column=1)

second_side_length_label = tk.Label(root, text="Second Side Length:")
second_side_length_label.grid(row=1, column=0)
second_side_length_entry = tk.Entry(root)
second_side_length_entry.grid(row=1, column=1)

initial_length_label = tk.Label(root, text="Initial Length:")
initial_length_label.grid(row=2, column=0)
initial_length_entry = tk.Entry(root)
initial_length_entry.grid(row=2, column=1)

velocity_label = tk.Label(root, text="Velocity:")
velocity_label.grid(row=3, column=0)
velocity_entry = tk.Entry(root)
velocity_entry.grid(row=3, column=1)

test_length_label = tk.Label(root, text="Test Length:")
test_length_label.grid(row=4, column=0)
test_length_entry = tk.Entry(root)
test_length_entry.grid(row=4, column=1)

# Tworzy przyciski
execute_test_button = tk.Button(root, text="Execute Test", command=execute_test)
execute_test_button.grid(row=5, column=0, columnspan=2)

move_upwards_button = tk.Button(root, text="Move Upwards", command=move_upwards)
move_upwards_button.grid(row=6, column=0, columnspan=2)

move_downwards_button = tk.Button(root, text="Move Downwards", command=move_downwards)
move_downwards_button.grid(row=7, column=0, columnspan=2)

set_values_button = tk.Button(root, text="Set Values", command=set_values)
set_values_button.grid(row=8, column=0, columnspan=2)

# Uruchamia pętlę główną programu
root.mainloop()


