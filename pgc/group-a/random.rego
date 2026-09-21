package terraform


random_number = num {
    request := {
        "url": "https://www.random.org/integers/?num=1&min=0&max=1&base=10&col=1&format=plain",
        "method": "GET"
    }
    response := http.send(request)
    response.status_code == 200
    num := to_number(trim(response.raw_body, "\n"))
}

deny[reason] {
    number := random_number
    number == 0

    reason := sprintf(
        "Unlucky you (loh): got %d, but 1 is required",
        [number]
    )
}