package ir.Stream;

import ir.Stream.mockdata.MockData;
import ir.Stream.model.Person;
import ir.Stream.model.PersonSummary;

import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        List<Person> personList = MockData.getPeople();
        assert personList != null;
        filterUpFifty(personList);
        userNameSortedList(personList);
        ageAndLastNameSortedList(personList);
        mappedListBaseOnIpV4(personList);
        mappedListBaseOnGendersAndAge(personList);
        calculateAverageAgeOfMen(personList);
    }


    public static void filterUpFifty(List<Person> person) {
        List<Person> filteredList = person.stream().filter(person1 -> person1.getAge() > 50).toList();
        filteredList.forEach(System.out::println);
    }

    public static void userNameSortedList(List<Person> person) {
        List<Person> sortedList = person.stream()
                .sorted(Comparator.comparing(Person::getUsername)).toList();
        sortedList.forEach(System.out::println);
    }

    public static void ageAndLastNameSortedList(List<Person> person) {
        List<Person> sortedList = person.stream()
                .sorted(Comparator.comparingInt(Person::getAge).thenComparing(Person::getLastName))
                .toList();
        sortedList.forEach(System.out::println);
    }

    public static void mappedListBaseOnIpV4(List<Person> person) {
        List<String> mappedList = person.stream()
                .map(Person::getIpv4).toList();
        mappedList.forEach(System.out::println);
    }

    public static void mappedListBaseOnGendersAndAge(List<Person> personList) {
        System.out.println(personList.stream().sorted(Comparator.comparing(Person::getLastName))
                .filter(person -> !(person.getGender().equals("Female") && person.getAge() > 40))
                .sorted(Comparator.comparing(Person::getFirstName))
                .dropWhile(person -> person.getFirstName().startsWith("A"))
                .skip(5).limit(100).collect(Collectors.toMap(
                        person -> person.getFirstName() + " " + person.getLastName(),
                        person -> person,
                        (existingPerson, newPerson) -> existingPerson
                )));
    }

    public static void calculateAverageAgeOfMen(List<Person> people) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d/M/yyyy");

        long totalAgeOfMen = people.stream()
                .filter(person -> person.getGender().equals("Male"))
                .mapToInt(person -> {
                    PersonSummary summary = new PersonSummary();
                    summary.setId(person.getId());
                    summary.setFirstName(person.getFirstName());
                    summary.setLastName(person.getLastName());

                    LocalDate birthDateParsed = LocalDate.parse(person.getBirthDate(), formatter);
                    int age = Period.between(birthDateParsed, LocalDate.now()).getYears();
                    summary.setAge(age);

                    summary.setBirthDate(Date.from(birthDateParsed.atStartOfDay().atZone(ZoneId.systemDefault()).toInstant()));

                    return summary.getAge();
                })
                .sum();

        long numberOfMen = people.stream()
                .filter(person -> person.getGender().equals("Male"))
                .count();

        System.out.println((double) totalAgeOfMen / numberOfMen);
    }

}