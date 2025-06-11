package com.mysite.todolist;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

import static  org.junit.jupiter.api.Assertions.assertFalse;

@SpringBootTest
public class DatabaseConnectionTest {

    @Autowired
    private DataSource dataSource;

    @Test
    void testConnection() throws Exception {
        // DataSource에서 Connection을 가져와서 닫아보는 테스트
        try (Connection conn = dataSource.getConnection()) {
            // 연결이 유효한지 검사
            assertFalse(conn.isClosed());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
