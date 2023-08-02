package ir.Stream;


import ir.Stream.mockdata.MockData;
import ir.Stream.model.Person;

import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<Person> person = MockData.getPeople();
        assert person != null;
        person.forEach(System.out::println);
    }
}